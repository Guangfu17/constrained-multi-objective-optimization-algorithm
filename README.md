# constrained-multi-objective-optimization-algorithm
Constrained Multi-objective Optimization for IoT-enabled Computation Offloading   
in Collaborative Edge and Cloud Computing, IEEE Internet of Things, 2021.

PPSNSGA2.m, PPSSPEA2.m, PPSSPEA2SDE are the algorithms. LIRCMOP7 is an example of problem.  
Run the algorithm:    
main('-algorithm',Value,'-problem',Value,...) runs one algorithm on a problem with acceptable parameters.  
For example: main('-algorithm',@PPSNSGA2,'-problem',LIRCMOP7,'-N',200,'-M',2)  

All the acceptable parameters:  
%   '-N'            <positive integer>  population size  
%   '-M'            <positive integer>  number of objectives  
%   '-D'            <positive integer>  number of variables  
%	  '-algorithm'    <function handle>   algorithm function  
%	  '-problem'      <function handle>   problem function  
%	  '-evaluation'   <positive integer>  maximum number of evaluations  
%   '-run'          <positive integer>  run number  
%   '-save'         <integer>           number of saved populations  
%   '-outputFcn'	  <function handle>   function invoked after each generation  
