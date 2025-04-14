clear;
clc;
rng(20250306);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% Set up for model selection
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
Var={'Year_Report','Region','Race','Mother_Education'};

num_M=2^length(Var);

bin_model=dec2bin([0:num_M-1]',length(Var))=='1';

Income_Var={'Income_Poverty_Ratio'};


for ii=0:length(Income_Var)
   for vv=1:num_M
        if(ii==0 && vv==1)
            Income_Mat=false(1,length(Income_Var));
        elseif(ii==0)
            Income_Mat=[Income_Mat; false(1,length(Income_Var))];
        else
            Income_Mat=[Income_Mat; ismember(Income_Var,Income_Var{ii})];
        end

        if(ii==0 && vv==1)
            Var_Mat=bin_model(vv,:);
        else
            Var_Mat=[Var_Mat; bin_model(vv,:)];
        end
   end
end

Num_Samp=10^3;

Total_Models=size(Var_Mat,1);
delta_AIC=zeros(Total_Models,Num_Samp);
w_AIC=zeros(Total_Models,Num_Samp);

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%555
% % Run numerous samples
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%555

for ss=1:Num_Samp
    Samp_Data=Random_Data();
    
    Samp_Data=Samp_Data(~strcmp(Samp_Data.Dropout,'NaN') & ~isnan(Samp_Data.Income_Poverty_Ratio),:);
    % Samp_Data=Samp_Data(strcmp(Samp_Data.Race,'NON-HISPANIC BLACK ONLY') | strcmp(Samp_Data.Race,'NON-HISPANIC WHITE ONLY'),:);
    
    Samp_Data.Dropout=double(strcmp(Samp_Data.Dropout,'Dropout'));
    
    
    Samp_Data.Year_Report=categorical(Samp_Data.Year_Report,2022:-1:2016);
    Samp_Data.Region=categorical(Samp_Data.Region);    
    Samp_Data.Race=categorical(Samp_Data.Race,{'NON-HISPANIC WHITE ONLY','NON-HISPANIC BLACK ONLY','HISPANIC','NON-HISPANIC OTHER + MULTIPLE RACE'});
    Samp_Data.Mother_Education=categorical(Samp_Data.Mother_Education,{'College','No College'});
    
    
    
    X_table=Samp_Data(:,ismember(Samp_Data.Properties.VariableNames,[Var Income_Var]));
    Y=Samp_Data.Dropout;
    
    AIC=zeros(Total_Models,1);
    for mm=1:Total_Models
        var_inc=ismember(X_table.Properties.VariableNames,[Var(Var_Mat(mm,:)) Income_Var(Income_Mat(mm,:))]);
        mdl = fitglm(X_table(:,var_inc),Y,'Distribution','binomial');
        AIC(mm)=mdl.ModelCriterion.AIC;
    end
    delta_AIC(:,ss)=AIC-min(AIC);
    w_AIC(:,ss)=exp(-delta_AIC(:,ss)./2)./sum(exp(-delta_AIC(:,ss)./2));
end

avg_delat_AIC=mean(delta_AIC,2);

p_AIC=mean(w_AIC,2);

Model_Summary=[array2table(Income_Mat) array2table(Var_Mat) table(avg_delat_AIC,p_AIC)];
Model_Summary.Properties.VariableNames=[Income_Var Var {'Average_delat_AIC'} {'Probability_Best_Model'}];

[~,s_indx]=sort(p_AIC);

Model_Summary=Model_Summary(s_indx,:);

save('NIS_Teen_Model_Selection_All_Races.mat','Model_Summary');

