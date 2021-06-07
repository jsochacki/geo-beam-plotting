clear all
clc

addpath('./library');
 
payload_longitude = 310;

%Beam Centers
xcenter = [-57.3417; -57.3417];
ycenter = [32.9; 29.7023];

beam_center = [xcenter, ycenter];
beam_virtual_earth_station_heights_m = zeros(size(beam_center,1), 1);
for n = 1:1:size(beam_center,1)
   beam_virtual_earth_station_heights_m(n) = get_height_relative_to_WGS84_ellipsoid(beam_center(n,2), beam_center(n,1));
end

theta = generate_geo_payload_thetas(beam_center, payload_longitude, beam_virtual_earth_station_heights_m);
bearings = get_initial_bearing([payload_longitude 0] .* ones(size(beam_center,1),1), beam_center);

boresight_thetas = theta;
half_beamwidth_in_degrees = 6; %0.42 rx and 0.28 tx for 1.1 m antenna

[ellipses] ...
         = generate_distorted_geo_beams(boresight_thetas, ...
                                        bearings, ...
                                        payload_longitude, ...
                                        half_beamwidth_in_degrees, ...
                                        beam_virtual_earth_station_heights_m);

fhandle1 = figure;
gx2 = geoaxes;
geobasemap(gx2, 'landcover')
plot_geobeamsmap(gx2, ellipses)
plot_geobeamsmap_outline(gx2, ellipses)

hgeo = constants('orbital', 'mean_geosynchronous_orbit_distance_from_equator_in_m');
uif1 = uifigure;
gg2 = geoglobe(uif1,'Basemap','landcover');
campos(gg2,0,payload_longitude, hgeo)
plot_geobeamsglobe(gg2, ellipses, 8000*ones(size(ellipses,1),1))
plot_geobeamsglobe_outline(gg2, ellipses, 8000)
% Check agains non ellipse fit shape to make sure it hasn't become hyperbolic
% plot_geobeamsglobe(gg2, contourso, 8000*ones(size(points_in_mask,1),1))
