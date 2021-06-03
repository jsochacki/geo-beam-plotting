function result = K_bi_cubic_interpolation1144(gamma)
   %ITU formula has an error as multiple conditions are true for their
   %formula when agamma = 1 and 2 so here i just assume and hope for the
   %best
   result = 0; % if agamma >= 2 case initialization
   a = -0.5;
   agamma = abs(gamma);
   if(agamma < 1)
      result = (((a + 2) * power(agamma, 3)) ...
         - ((a + 3) * power(agamma, 2))) + 1;
   elseif((1 <= agamma) & (agamma < 2))
      result = ((a * power(agamma, 3)) + (8 * a * agamma)) ...
         - (5 * a * power(agamma, 2)) - (4 * a);
   end
end