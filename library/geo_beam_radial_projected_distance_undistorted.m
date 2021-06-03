function radial_distance ...
   = geo_beam_radial_projected_distance_undistorted(half_beamwidth_in_degrees, ...
                                                    earth_station_heights_m)

%%
% This returns the distance along the surface of the earth at 
% earth_station_heights_m spanned by the half_beamwidth_in_degrees directly
% satellite nadir

Re = constants('geographical', 'mean_earth_radius_in_m');
h = constants('orbital', 'mean_geosynchronous_orbit_distance_from_equator_in_m');

eshim = earth_station_heights_m;

alpha = half_beamwidth_in_degrees * (pi / 180);

radmax = asin((Re + eshim) / (Re + h));

% Prevent imaginary thetas the represent beam coverage beyond the edge of the
% globe, just represent beams on the visible globe
tindex = find(alpha > radmax);
alpha(tindex) = radmax(tindex);

sroer = (Re + h) ./ (Re + eshim);
theta = asin(sin(alpha).*sroer) - alpha;
D = theta .* (Re + eshim);
radial_distance = D;

end