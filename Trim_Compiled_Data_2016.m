clear;
clc;

load('MEN_VAC_DATA_COMPILED.mat');

t_2016=Year_Report>=2016;

No_Vac_Reason.No_Doctor=No_Vac_Reason.No_Doctor(t_2016);
No_Vac_Reason.Not_Available=No_Vac_Reason.Not_Available(t_2016);
No_Vac_Reason.Not_Needed=No_Vac_Reason.Not_Needed(t_2016);
No_Vac_Reason.Not_Req_School=No_Vac_Reason.Not_Req_School(t_2016);
No_Vac_Reason.Time=No_Vac_Reason.Time(t_2016);
No_Vac_Reason.Trouble_Appointment=No_Vac_Reason.Trouble_Appointment(t_2016);
State_Data=State_Data(t_2016);
Race_Data=Race_Data(t_2016);
Age_Data=Age_Data(t_2016);
Mother_Education_Data=Mother_Education_Data(t_2016);
Income_Poverty_Ratio_Data=Income_Poverty_Ratio_Data(t_2016);
Poverty_Data=Poverty_Data(t_2016);
Family_Income_Data=Family_Income_Data(t_2016);
Age_Vac_Data=Age_Vac_Data(t_2016,:);
Weight=Weight(t_2016);
Vac_Data=Vac_Data(t_2016);
Year_Report=Year_Report(t_2016);
Year_Vac=Year_Vac(t_2016,:);
Birth_Year=Birth_Year(t_2016);

clearvars t_2016;

save('MEN_VAC_DATA_TRIMMED_2016_2022.mat');

