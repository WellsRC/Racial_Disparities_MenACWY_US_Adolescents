clear;
clc;

rng(20250306);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% Set up for model selection
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
Var={'Year_Report','Region','Race','Mother_Education','Not_Needed_or_Required','Access_to_Care'};

Income_Var={'Income_Poverty_Ratio'};

load('NIS_Teen_Model_Selection_One_Dose_All_Races.mat','One_Dose_Model_Summary');


One_Dose_Model_Summary=sortrows(One_Dose_Model_Summary,width(One_Dose_Model_Summary),'descend');

Samp_Data=Random_Data();

Samp_Data=Samp_Data(Samp_Data.Year_Report>=2016 & ~isnan(Samp_Data.Income_Poverty_Ratio),:);


Samp_Data.Year_Report=categorical(Samp_Data.Year_Report,2022:-1:2016);
Samp_Data.Region=categorical(Samp_Data.Region);
Samp_Data.Race=categorical(Samp_Data.Race,{'NON-HISPANIC WHITE ONLY','NON-HISPANIC BLACK ONLY','HISPANIC','NON-HISPANIC OTHER + MULTIPLE RACE'});
Samp_Data.Mother_Education=categorical(Samp_Data.Mother_Education,{'College','No College'});


mdl=cell(5,1);
for mm=1:5    
    MV=[Var(table2array(One_Dose_Model_Summary(mm,2:7))) Income_Var(One_Dose_Model_Summary.Income_Poverty_Ratio(mm))];
    X_table=Samp_Data(:,ismember(Samp_Data.Properties.VariableNames,MV));
    Y=double(Samp_Data.Number_of_Doses>0);
    mdl{mm} = fitglm(X_table,Y,'Distribution','binomial');
end


AIC_mdl=mdl{1};

ci=coefCI(AIC_mdl);
Estimate=cell(length(AIC_mdl.CoefficientNames),1);
Odds=cell(length(AIC_mdl.CoefficientNames),1);
pValue=cell(length(AIC_mdl.CoefficientNames),1);

for ii=1:length(Estimate)
    Estimate{ii}=[num2str(AIC_mdl.Coefficients.Estimate(ii),'%4.3f') ' (95% CI: ' num2str(ci(ii,1),'%4.3f') char(8211) num2str(ci(ii,2),'%4.3f') ')'];
    if(ii>1)
        Odds{ii}=[num2str(exp(AIC_mdl.Coefficients.Estimate(ii)),'%3.2f') ' (95% CI: ' num2str(exp(ci(ii,1)),'%3.2f') char(8211) num2str(exp(ci(ii,2)),'%3.2f') ')'];
    end
    if(AIC_mdl.Coefficients.pValue(ii)<0.001)
        pValue{ii}=num2str(AIC_mdl.Coefficients.pValue(ii),'%3.2e');
    else
        pValue{ii}=num2str(AIC_mdl.Coefficients.pValue(ii),'%4.3f');
    end
end
Variable=AIC_mdl.CoefficientNames';
Table_AIC=table(Variable,Estimate,Odds,pValue);


% Samp_Data=Samp_Data(strcmp(Samp_Data.Race,'NON-HISPANIC BLACK ONLY') | strcmp(Samp_Data.Race,'NON-HISPANIC WHITE ONLY'),:);



% Num_Yr_Report=zeros(height(Samp_Data),length(2018:2022));
% for yy=2018:2022
%     Num_Yr_Report(:,yy-2017)=double(Samp_Data.Year_Report==yy);
% end
% 
% Num_Region=zeros(height(Samp_Data),10);
% for rr=1:10
%     Num_Region(:,rr)=double(Samp_Data.Region==rr);
% end
% 
% Num_Race=zeros(height(Samp_Data),2);
% Num_Race(:,1)=double(strcmp(Samp_Data.Race,'NON-HISPANIC BLACK ONLY'));
% Num_Race(:,2)=double(~strcmp(Samp_Data.Race,'NON-HISPANIC BLACK ONLY'));
% 
% U=unique(Samp_Data.Mother_Education);
% Num_Mother_Eduction=zeros(height(Samp_Data),length(U));
% for ii=1:length(U)
%     Num_Mother_Eduction(:,ii)=strcmp(Samp_Data.Mother_Education,U{ii});
% end
% 
% Num_Not_Needed_or_Required=Samp_Data.Not_Needed_or_Required;
% Num_Access_to_Care=Samp_Data.Access_to_Care;
% 
% Num_IPR=Samp_Data.Income_Poverty_Ratio;

% 
% 
% VIF_X=[Num_IPR Num_Yr_Report(:,2:end) Num_Region(:,2:end) Num_Race(:,1) Num_Mother_Eduction(:,2:end) Num_Not_Needed_or_Required(:) Num_Access_to_Care(:)];
% xx=[1:size(VIF_X,2)];
% VIF=zeros(size(VIF_X,2),1);
% for vv=1:size(VIF_X,2)
%     if(vv==1)
%         mdl_vif = fitglm(VIF_X(:,xx~=vv),VIF_X(:,vv));
%     else
%         mdl_vif = fitglm(VIF_X(:,xx~=vv),VIF_X(:,vv),'Distribution','binomial');
%     end
%     VIF(vv)=1./(1-mdl_vif.Rsquared.Ordinary);
% end
% 
% VIF_Variable={'Income_Poverty_Ratio'; 'Year_2019'; 'Year_2020'; 'Year_2021'; 'Year_2022'; 'Region_2'; 'Region_3'; 'Region_4'; 'Region_5'; 'Region_6'; 'Region_7'; 'Region_8'; 'Region_9'; 'Region_10'; 'Race_White'; 'College_Graduate';'Less_than_12_Years';'More_than_12_years_non_collge_grad';'Not_required';'Access_to_Care'};
% 
% VIF_Table=table(VIF_Variable,VIF);
% 
% save('VIF_One_Dose.mat','VIF_Table','mdl');