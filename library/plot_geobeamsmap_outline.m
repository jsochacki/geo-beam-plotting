function plot_geobeamsmap_outline(ax, points)

N = size(points, 3);
polyshape_array = [];
for index = 1:1:N
   polyshape_array = [polyshape_array polyshape(points(:,:,index))];
end
polygon = union(polyshape_array);
[xextents,yextents] = boundary(polygon)
hold(ax,'on');
geoplot(ax,xextents, yextents, 'r')

end