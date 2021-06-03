function plot_geobeamsglobe_outline(ax, points, alt)

N = size(points, 3);
polyshape_array = [];
for index = 1:1:N
   polyshape_array = [polyshape_array polyshape(points(:,:,index))];
end
polygon = union(polyshape_array);
[xextents,yextents] = boundary(polygon)
hold(ax,'on');
mygeoplot3(ax,xextents, yextents, alt .* ones(length(xextents),1), 'r')
 
end