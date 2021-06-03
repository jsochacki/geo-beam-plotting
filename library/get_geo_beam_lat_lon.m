function endpoints = get_geo_beam_lat_lon(point, distance_in_m, bearing)
%%
% This gives you the lat and lon you would end up at if you start at the lat lon
% in point and travel distance at bearing along a great circle rout
%
% This is the case (great circle calculations) for calculating beam
% distortion extension for geo calculations as the extension is along great
% circle lines (lines that bisect the center of the core of the earth)
%
% This will NOT not be the case for non synchronous orbiting payloads beam
% calculations
%
%% bearing
% This must be clockwise from the north where north is 0 degrees

Re = constants('geographical', 'mean_earth_radius_in_m');

radlats = point(:,2) * (pi / 180);
radlons = point(:,1) * (pi / 180);

radadist = distance_in_m / Re;

radbearing = bearing * (pi / 180);

endradlats = asin((sin(radlats) .* cos(radadist)) + (cos(radlats) .* sin(radadist) .* cos(radbearing)));
endradlon = atan2(sin(radbearing) .* sin(radadist) .* cos(radlats), cos(radadist) - (sin(radlats) .* sin(endradlats)));
endradlon = mod(radlons + endradlon + pi, 2*pi) - pi;
% DONT use these below, his coordinate system for longitude is not standard
% satellite coordinates and goes from 0 to 180 then wraps to -180 to 0 rather
% than just going from -180 to 180
% endradlon = mod(radlons - endradlon + pi, 2*pi) - pi;
% %endlon = mod(radlons - enddlon + 3*pi, 2*pi) - pi; %If you want to play it really safe

endpoints = [endradlats endradlon] * (180 / pi);

end