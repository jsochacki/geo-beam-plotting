function theta = generate_geo_payload_thetas(points, payload_longitude, earth_station_heights_m)

Re = constants('geographical', 'mean_earth_radius_in_m');
h = constants('orbital', 'mean_geosynchronous_orbit_distance_from_equator_in_m');
%Just use mean local height as it is already a rough number from the way the
%calculations are done, this should be at the place of projection and not below
%the satellite

fromlats = points(:,2);
fromlons = points(:,1);
fromh = earth_station_heights_m;
tolat = 0;
tolon = payload_longitude;
toh = h;
[~, ...
 elevation_angle_degrees, ...
 slantRange] ...
 = geodetic2aer(tolat,tolon,toh,fromlats,fromlons,fromh,wgs84Ellipsoid);
% Note do not use az here as it is NOT the same as the bearing angle and will
% give a wrong answer, just throw it away and calculate actual bearing

a = Re + h;
b = Re + fromh;

AA = (pi / 180) * (90 + elevation_angle_degrees);
BA = asin(b ./ (a ./ sin( AA )));
CA = pi - (AA + BA); 

% 0 alpha (theta) is nadir
theta = (180 / pi) * BA;
end