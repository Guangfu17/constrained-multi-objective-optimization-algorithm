function PPSNSGA2(Global)
% <algorithm> <P>
% "PlatEMO"

%------------------------------- Reference --------------------------------
% Constrained Multi-objective Optimization for IoT-enabled
% Computation Offloading in Collaborative Edge and Cloud Computing.
%------------------------------- Reference --------------------------------


%% Parameter setting
type = 2; % GA or DE operator

%% Generate random population
Population = Global.Initialization();
[~,FrontNo1,CrowdDis1] = EnvironmentalSelection1(Population,Global.N);  %--------------without considering constraint
[~,FrontNo2,CrowdDis2] = EnvironmentalSelection2(Population,Global.N);  %--------------without considering constraint


%% Evaluate the Population
last_gen         = 20;
change_threshold = 1e-3;
search_stage     = 1; % 1 for push stage,otherwise,it is in pull stage.
max_change       = 1;
ideal_points     = zeros(Global.maxgen,Global.M);
nadir_points     = zeros(Global.maxgen,Global.M);


%% Optimization
while Global.NotTermination(Population)
    pop_cons                   = Population.cons;
    cv                         = overall_cv(pop_cons);
    population                 = [Population.decs,Population.objs,cv];
    
    ideal_points(Global.gen,:) = min(population(:,Global.D + 1 : Global.D + Global.M),[],1);  
    nadir_points(Global.gen,:) = max(population(:,Global.D + 1 : Global.D + Global.M),[],1);
    
    % The maximumrate of change of ideal and nadir points rk is calculated.
    if Global.gen >= last_gen
        max_change = calc_maxchange(ideal_points,nadir_points,Global.gen,last_gen);
    end
    
    if max_change <= change_threshold && search_stage == 1
        search_stage = -1;
    end
    
    if search_stage == 1 % Push Stage
        
        if type == 1
            MatingPool1 = TournamentSelection(2,Global.N,FrontNo1,-CrowdDis1);
            Offspring1  = GA(Population(MatingPool1));
        elseif type == 2
            MatingPool1 = TournamentSelection(2,2*Global.N,FrontNo1,-CrowdDis1);
            Offspring1  = DE(Population,Population(MatingPool1(1:end/2)),Population(MatingPool1(end/2+1:end)));
        end
        [Population,FrontNo1,CrowdDis1] = EnvironmentalSelection1([Population,Offspring1],Global.N);
        
    else  % Pull Stage
        
        if type == 1
            MatingPool2 = TournamentSelection(2,Global.N,FrontNo2,-CrowdDis2);
            Offspring2  = GA(Population(MatingPool2));
        elseif type == 2
            MatingPool2 = TournamentSelection(2,2*Global.N,FrontNo2,-CrowdDis2);
            Offspring2  = DE(Population,Population(MatingPool2(1:end/2)),Population(MatingPool2(end/2+1:end)));
        end
        [Population,FrontNo2,CrowdDis2] = EnvironmentalSelection2([Population,Offspring2],Global.N);
    end
    
end
end

% The Overall Constraint Violation
function result = overall_cv(cv)
cv(cv <= 0) = 0;cv = abs(cv);
result = sum(cv,2);
end

% Calculate the Maximum Rate of Change
function max_change = calc_maxchange(ideal_points,nadir_points,gen,last_gen)
delta_value = 1e-6 * ones(1,size(ideal_points,2));
rz = abs((ideal_points(gen,:) - ideal_points(gen - last_gen + 1,:)) ./ max(ideal_points(gen - last_gen + 1,:),delta_value));
nrz = abs((nadir_points(gen,:) - nadir_points(gen - last_gen + 1,:)) ./ max(nadir_points(gen - last_gen + 1,:),delta_value));
max_change = max([rz, nrz]);
end

