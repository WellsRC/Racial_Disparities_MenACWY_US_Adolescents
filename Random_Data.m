function Samp_Data=Random_Data()

load('State_Regional_Number.mat','Regional_Number');
Regional_Code=unique([Regional_Number{:,2}]);

NS_Year=10000;
load('MEN_VAC_DATA_TRIMMED_2016_2022.mat');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% Regional code number
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Regional_Code=zeros(size(State_Data));
for ss=1:length(State_Data)
    tf=strcmp(State_Data{ss},{Regional_Number{:,1}});
    Regional_Code(ss)=Regional_Number{tf,2};
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% Age and year of vaccination
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Age_First_Dose=Age_Vac_Data(:,1);
Age_Second_Dose=Age_Vac_Data(:,2);
Age_Third_Dose=Age_Vac_Data(:,3);

Year_First_Dose=Year_Vac(:,1);
Year_Second_Dose=Year_Vac(:,2);
Year_Third_Dose=Year_Vac(:,3);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Reason not vaccinate
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Not_Needed_or_Required=double(No_Vac_Reason.Not_Needed | No_Vac_Reason.Not_Req_School);
Access_to_Care=double(No_Vac_Reason.Not_Available | No_Vac_Reason.No_Doctor)+No_Vac_Reason.Trouble_Appointment;

Not_Needed_or_Required(isnan(No_Vac_Reason.Trouble_Appointment))=NaN;
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Recode family income data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
N={'$0-$30000','$30001-$75000','$75001+','DONT KNOW','REFUSE'};
U=unique(Family_Income_Data);
U=U([1 12 2:11 13 14]);
RECODE_FAMILY_INCOME=cell(size(Family_Income_Data));
for ii=1:6
    tf=strcmp(Family_Income_Data,U{ii});
    RECODE_FAMILY_INCOME(tf)=N(1);
end
for ii=7:11
    tf=strcmp(Family_Income_Data,U{ii});
    RECODE_FAMILY_INCOME(tf)=N(2);
end
for ii=12:14
    tf=strcmp(Family_Income_Data,U{ii});
    RECODE_FAMILY_INCOME(tf)=N(3+(ii-12));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Determine Dropout
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Dropout_2011_2022=cell(size(Vac_Data));

logic_age_17=Age_Data==17;
logic_first_dose=Age_First_Dose<16;
logic_booster_dose=Age_Second_Dose>=16 | Age_Third_Dose>=16;

logical_not_dropped=logic_age_17 & logic_first_dose & logic_booster_dose & Year_Report>=2011;
logical_dropped=logic_age_17 & logic_first_dose & ~logic_booster_dose & Year_Report>=2011;

Dropout_2011_2022(Year_Report<2011)={'NaN'};
Dropout_2011_2022(~logic_age_17 | ~logic_first_dose)={'NaN'};
Dropout_2011_2022(logical_not_dropped)={'No dropout'};
Dropout_2011_2022(logical_dropped)={'Dropout'};



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% Create table
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5

Raw_Data=table(Year_Report,Age_Data,Vac_Data,Age_First_Dose,Age_Second_Dose,Age_Third_Dose,Year_First_Dose,Year_Second_Dose,Year_Third_Dose,Dropout_2011_2022,State_Data,Regional_Code,Race_Data,Family_Income_Data,RECODE_FAMILY_INCOME,Income_Poverty_Ratio_Data,Poverty_Data,Mother_Education_Data,Not_Needed_or_Required,Access_to_Care);

Raw_Data.Properties.VariableNames={'Year_Report','Age','Number_of_Doses','Age_First_Dose','Age_Second_Dose','Age_Third_Dose','Year_First_Dose','Year_Second_Dose','Year_Third_Dose','Dropout','State','Region','Race','Family_Income_Bracket','Recoded_Family_Income_Bracket','Income_Poverty_Ratio','Poverty_Status','Mother_Education','Not_Needed_or_Required','Access_to_Care'};
for Yr=2016:2022 %2008:2022
    f_indx_data=find(Raw_Data.Year_Report==Yr);
    w=Weight(Raw_Data.Year_Report==Yr);
    w=cumsum(w)./sum(w);
    rand_indx=zeros(NS_Year,1);
    for ss=1:NS_Year
        indx_rnd=find(rand(1)<=w,1,'first');
        rand_indx(ss)=f_indx_data(indx_rnd);
    end
    if(Yr==2016)
        Samp_Data=Raw_Data(rand_indx,:);
    else
        Samp_Data=[Samp_Data; Raw_Data(rand_indx,:)];
    end
end

tf=strcmp(Samp_Data.Mother_Education,'MORE THAN 12 YEARS NON-COLLEGE GRAD')	| strcmp(Samp_Data.Mother_Education,'COLLEGE GRADUATE');

Samp_Data.Mother_Education(tf)={'College'};
Samp_Data.Mother_Education(~tf)={'No College'};
end