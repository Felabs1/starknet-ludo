program DecimalCalculation;
var
   a, b ,c, ret : real;


function sumDecimal(num1, num2, num3: real): real;
var
   (* local variable declaration *)
   result: real;

begin
   result = num1 + num2 + num3;
   sumDecimal := result;
end;

begin
   writeln('enter num 1');
   readln(a);
   writeln('enter num 2');
   readln(b);
   writeln('enter num 3');
   readln(c);

   ret := sumDecimal(a, b, c);
   writeln( 'Max value is : ', ret );
end.