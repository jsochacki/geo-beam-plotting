function [ellipses] ...
            = generate_distorted_geo_beams(boresight_thetas, ...
                                           bearings, ...
                                           payload_longitude, ...
                                           half_beamwidth_in_degrees, ...
                                           earth_station_heights_m)

%%
% phi is zero at north, 90 at east, -90 at west etc... as it comes out of
% get_initial_bearing

Re = constants('geographical', 'mean_earth_radius_in_m');
h = constants('orbital', 'mean_geosynchronous_orbit_distance_from_equator_in_m');

eshim = earth_station_heights_m;

s = boresight_thetas * (pi / 180);
alpha = half_beamwidth_in_degrees * (pi / 180);

radmax = asin((Re + eshim) / (Re + h)).*0.99999999;
thetamax = (180 / pi) * radmax;

sma = (s - alpha);
spa = (s + alpha);
bs = s;

% Prevent imaginary thetas the represent beam coverage beyond the edge of the
% globe, just represent beams on the visible globe
tindex = find(sma > radmax);
sma(tindex) = radmax(tindex);
tindex = find(spa > radmax);
spa(tindex) = radmax(tindex);
tindex = find(bs > radmax);
bs(tindex) = radmax(tindex);

sroer = (Re + h) ./ (Re + eshim);
theta_near = asin(sin(sma).*sroer) - sma;
theta_far = asin(sin(spa).*sroer) - spa;
theta_bs = asin(sin(bs).*sroer) - bs;

Dnear = theta_near .* (Re + eshim);
Dfar = theta_far .* (Re + eshim);
Dboresight = theta_bs .* (Re + eshim);

DSMA = Dfar - Dnear;

elevation_near = ((pi / 2) - theta_near) - sma;
elevation_far = ((pi / 2) - theta_far) - spa;
elevation_bs = ((pi / 2) - theta_bs) - bs;


Dmiddle = Dnear + (DSMA / 2);

% Approach 1: simplest approach, just start at lat, lon under satellite and then
% figure out all others from there, should work due to all being on great circle
% but could incurr more error as you are projecting over longer distances and
% relies on get_geo_beam_lat_lon being precise and corrct

indexes = find(bearings<0);
bearings(indexes) = bearings(indexes) + 360;
% Now it is clockwise from north as required by get_geo_beam_lat_lon
%bearing = mod(phi + 180, 360); %This is to point to dnear from boresight

beam_undistorted_radii_in_m ...
   = geo_beam_radial_projected_distance_undistorted(half_beamwidth_in_degrees, ...
                                                    earth_station_heights_m);

% Generate the radial offset in lat degrees for undistorted beam by proecting
% directly towards north of satellite nadir (you can pretend it is at 0 EW slot 
% as it doesn't matter if you want and change [payload_longitude 0] to [0 0] 
temp = get_geo_beam_lat_lon([payload_longitude 0], beam_undistorted_radii_in_m, 0);
beam_undistorted_radii_in_degrees = temp(:, 1);

ellipse_points = zeros(4, 2, size(boresight_thetas,1));
ellipse_radii = zeros(size(boresight_thetas,1),1);
Npoints_elipse = 100;
ellipses = zeros(Npoints_elipse + 1, 2, size(boresight_thetas,1));
for n = 1:1:size(boresight_thetas,1)
   % all the same for approach 1, outward from spacecraft nadir
   bearing = bearings(n);
   distance_in_m = [Dfar(n); Dmiddle(n); Dboresight(n); Dnear(n)];
   point = [payload_longitude 0];
   ellipse_points(:, :, n) = get_geo_beam_lat_lon(point, distance_in_m, bearing);
   
   local_points = squeeze(ellipse_points(:,:,n));
   start_point = [local_points(1,1) payload_longitude - local_points(1,2)];
   end_point = [local_points(4,1) payload_longitude - local_points(4,2)];

   ellipse_radii(n) = (sqrt(sum(power(start_point, 2))) ...
                      - sqrt(sum(power(end_point, 2)))) / 2;
%    ellipse_radii(n) = (sqrt(sum(power(ellipse_points(1,:,n), 2))) ...
%                       - sqrt(sum(power(ellipse_points(4,:,n), 2)))) / 2;

   % Make the ellipse
   tempelipse ...
      = make_ellipse(0, 0, beam_undistorted_radii_in_degrees(n), ellipse_radii(n), Npoints_elipse);
   
   % Rotate the ellipse
   tempelipse = rotate_clockwise(tempelipse, bearing);

   % Offset it to the final positon from 0 0 (where it needed to be for simple
   % rotation, row 2 is dmiddle and the elipse is in lon lat format so we put
   % centerpoint in lon lat and then fliplr at the end to get an ellipse that
   % can just be added to the map as a shape
   centerpoint = [ellipse_points(2,2,n) ellipse_points(2,1,n)];
   ellipses(:, :, n) = fliplr(centerpoint + tempelipse);
end

% Approach 2: harder approach, start at the known lat lon for each boresight
% point and generate Dmiddle lat lon, Dnear lat lon, and Dfar lat and lon from
% that

end