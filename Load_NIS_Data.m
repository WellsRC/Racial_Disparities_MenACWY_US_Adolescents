function [No_Vac_Reason,State_Data,Race_Data,Age_Data,Mother_Education_Data,Income_Poverty_Ratio_Data,Poverty_Data,Family_Income_Data,Age_Vac_Data,Year_Report,Weight,Race_Code,State_Code,Education_Code,Poverty_Code,Family_Income_Code]=Load_NIS_Data

Year_V=[2008:2022];
Race_Code={'HISPANIC';'NON-HISPANIC WHITE ONLY';'NON-HISPANIC BLACK ONLY';'NON-HISPANIC OTHER + MULTIPLE RACE'};
Education_Code={'LESS THAN 12 YEARS';'12 YEARS';'MORE THAN 12 YEARS NON-COLLEGE GRAD';'COLLEGE GRADUATE'};
Poverty_Code={'ABOVE POVERTY > $75K';'ABOVE POVERTY <= $75K';'BELOW POVERTY';'UNKNOWN'};
State_Code={'ALABAMA';'ALASKA';'ARIZONA';'ARKANSAS';'CALIFORNIA';'COLORADO';'CONNECTICUT';'DELAWARE';'DISTRICT OF COLUMBIA';'FLORIDA';'GEORGIA';'HAWAII';'IDAHO';'ILLINOIS';'INDIANA';'IOWA';'KANSAS';'KENTUCKY';'LOUISIANA';'MAINE';'MARYLAND';'MASSACHUSETTS';'MICHIGAN';'MINNESOTA';'MISSISSIPPI';'MISSOURI';'MONTANA';'NEBRASKA';'NEVADA';'NEW HAMPSHIRE';'NEW JERSEY';'NEW MEXICO';'NEW YORK';'NORTH CAROLINA';'NORTH DAKOTA';'OHIO';'OKLAHOMA';'OREGON';'PENNSYLVANIA';'RHODE ISLAND';'SOUTH CAROLINA';'SOUTH DAKOTA';'TENNESSEE';'TEXAS';'UTAH';'VERMONT';'VIRGINIA';'WASHINGTON';'WEST VIRGINIA';'WISCONSIN';'WYOMING';'PUERTO RICO'};
state_num=[1	2	4	5	6	8	9	10	11	12	13	15	16	17	18	19	20	21	22	23	24	25	26	27	28	29	30	31	32	33	34	35	36	37	38	39	40	41	42	44	45	46	47	48	49	50	51	53	54	55	56	72];

Family_Income_Values=[3:14 77 99];
Family_Income_Code={'$0 - $7500';'$7501 - $10000 ';'$10001 - $17500';'$17501 - $20000';'$20001 - $25000';'$25001 - $30000';'$30001 - $35000';'$35001 - $40000';'$40001 - $50000';'$50001 - $60000';'$60001 - $75000';'$75001+';'DONT KNOW';'REFUSED'};
for yy=1:length(Year_V)
    syear=num2str(Year_V(yy));
    T=readtable(['NISTEENPUF' syear(end-1:end) '.csv']);
    if(Year_V(yy)>=2018)
        VB=T.MEN_ANY;
        adq_prov=~isnan(str2double(T.PROVWT_C));
    elseif(Year_V(yy)==2017)
        VB=T.MEN_ANY;
        adq_prov=~isnan(str2double(T.PROVWT_D));
    elseif(Year_V(yy)>=2015)
        VB=T.MEN_ANY;
        adq_prov=~isnan(T.PROVWT_D);
    elseif(Year_V(yy)>=2011)        
        VB=T.MEN_ANY_REC;
        adq_prov=~isnan(T.PROVWT_D);
    else
        VB=T.MEN_ANY_REC;
        adq_prov=~isnan(T.PROVWT);
    end
    AV=str2double([T.MEN_AGE1 T.MEN_AGE2 T.MEN_AGE3 T.MEN_AGE4 T.MEN_AGE5 T.MEN_AGE6 T.MEN_AGE7 T.MEN_AGE8 T.MEN_AGE9]);
    AV=max(AV,[],2);
    T=T(VB<=2 & (str2double(T.MEN_AGE1)>=10 | isnan(str2double(T.MEN_AGE1))) & ~(AV>T.AGE) & adq_prov,:); % Focus on those receiving their first dose at age of 10 are later. Only a small perentage received prior to 10  

    Age_plus=str2double([T.MEN_AGE3 T.MEN_AGE4 T.MEN_AGE5 T.MEN_AGE6 T.MEN_AGE7 T.MEN_AGE8 T.MEN_AGE9]); % for those with three or more we are looking at the most recent dose
    Age_plus=max(Age_plus,[],2);


    state_indx=NaN.*zeros(size(T.STATE));
    
    for ii=1:length(state_num)
        f_state=state_num(ii)==T.STATE;
        state_indx(f_state)=ii;
    end

    family_income_indx=NaN.*zeros(size(T.STATE));

    for ii=1:length(Family_Income_Values)
        f_income=Family_Income_Values(ii)==T.INCQ298A;
        family_income_indx(f_income)=ii;
    end

    if(Year_V(yy)>=2018)
        Weight_temp=str2double(T.PROVWT_C);
    elseif(Year_V(yy)==2017)
        Weight_temp=str2double(T.PROVWT_D);
    elseif(Year_V(yy)>=2015)
        Weight_temp=T.PROVWT_D;
    elseif(Year_V(yy)>=2011)    
        Weight_temp=T.PROVWT_D;
    else
        Weight_temp=T.PROVWT;
    end

    if(yy==1)
        Race_Data=Race_Code(T.RACEETHK);
        Age_Data=T.AGE;       
        State_Data=State_Code(state_indx);
        Age_Vac_Data=[str2double([T.MEN_AGE1 T.MEN_AGE2]) Age_plus];
        Year_Report=Year_V(yy).*ones(size(T.AGE));
        Weight=Weight_temp;
        Mother_Education_Data=Education_Code(T.EDUC1);
        Income_Poverty_Ratio_Data=T.INCPORAR;
        Poverty_Data=Poverty_Code(T.INCPOV1);
        Family_Income_Data=Family_Income_Code(family_income_indx);
        No_Vac_Reason.Not_Needed=str2double(T.MEN_REAS_3)==1;
        No_Vac_Reason.Not_Req_School=str2double(T.MEN_REAS_4)==1;
        No_Vac_Reason.Not_Available=str2double(T.MEN_REAS_5)==1;
        No_Vac_Reason.Time=str2double(T.MEN_REAS_20)==1;
        No_Vac_Reason.No_Doctor=str2double(T.MEN_REAS_23)==1;
        if(Year_V(yy)>=2016)
            No_Vac_Reason.Trouble_Appointment=str2double(T.MEN_REAS_25)==1;
        else
            No_Vac_Reason.Trouble_Appointment=NaN.*zeros(height(T),1);
        end

    else
        Race_Data=[Race_Data; Race_Code(T.RACEETHK)];
        Age_Data=[Age_Data; T.AGE];
        State_Data=[State_Data;State_Code(state_indx)];
        Age_Vac_Data=[Age_Vac_Data; str2double([T.MEN_AGE1 T.MEN_AGE2]) Age_plus];
        Year_Report=[Year_Report; Year_V(yy).*ones(size(T.AGE))];
        Weight=[Weight; Weight_temp];
        Mother_Education_Data=[Mother_Education_Data;Education_Code(T.EDUC1)];
        Income_Poverty_Ratio_Data=[Income_Poverty_Ratio_Data;T.INCPORAR];
        Poverty_Data=[Poverty_Data; Poverty_Code(T.INCPOV1)];
        Family_Income_Data=[Family_Income_Data;Family_Income_Code(family_income_indx)];

        No_Vac_Reason.Not_Needed=[No_Vac_Reason.Not_Needed; str2double(T.MEN_REAS_3)==1];
        No_Vac_Reason.Not_Req_School=[No_Vac_Reason.Not_Req_School; str2double(T.MEN_REAS_4)==1];
        No_Vac_Reason.Not_Available=[No_Vac_Reason.Not_Available; str2double(T.MEN_REAS_5)==1];
        No_Vac_Reason.Time=[No_Vac_Reason.Time; str2double(T.MEN_REAS_20)==1];
        No_Vac_Reason.No_Doctor=[No_Vac_Reason.No_Doctor; str2double(T.MEN_REAS_23)==1];
        if(Year_V(yy)>=2016)
            No_Vac_Reason.Trouble_Appointment=[No_Vac_Reason.Trouble_Appointment; str2double(T.MEN_REAS_25)==1];
        else
            No_Vac_Reason.Trouble_Appointment=[No_Vac_Reason.Trouble_Appointment; NaN.*zeros(height(T),1)];
        end
    end
    

end

end