clear;
[No_Vac_Reason,State_Data,Race_Data,Age_Data,Mother_Education_Data,Income_Poverty_Ratio_Data,Poverty_Data,Family_Income_Data,Age_Vac_Data,Year_Report,Weight,Race_Code,State_Code,Education_Code,Poverty_Code,Family_Income_Code]=Load_NIS_Data();
Vac_Data=sum(~isnan(Age_Vac_Data),2);
Year_Vac=Year_Report-(repmat(Age_Data,1,3)-Age_Vac_Data);
Birth_Year=Year_Report-Age_Data;
save('MEN_VAC_DATA_COMPILED.mat');