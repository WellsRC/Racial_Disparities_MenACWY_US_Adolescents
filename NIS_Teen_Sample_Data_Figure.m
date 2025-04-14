clear;
clc;
close all;
NS=1000;

Yr=[2016:2022];
    
U_Family_Income={'$0 - $7500'	'$7501 - $10000 '	'$10001 - $17500'	'$17501 - $20000'	'$20001 - $25000'	'$25001 - $30000'	'$30001 - $35000'	'$35001 - $40000'	'$40001 - $50000'	'$50001 - $60000'	'$60001 - $75000'	'$75001+'};
U_Region=1:10;
U_Race={'HISPANIC'	'NON-HISPANIC BLACK ONLY'	'NON-HISPANIC OTHER + MULTIPLE RACE'	'NON-HISPANIC WHITE ONLY'};
U_Family_Income_RC={'$0-$30000'	'$30001-$75000'	'$75001+'};
U_Poverty={'BELOW POVERTY' 'ABOVE POVERTY <= $75K'	'ABOVE POVERTY > $75K'};
U_Mother_Education={'No College'	'College'};
U_Income_Poverty_Ratio=[0 1;1 2;2 3];

Vaccinated_Family_Income=zeros(NS,length(U_Family_Income),length(Yr));
Vaccinated_Family_Income_RC=zeros(NS,length(U_Family_Income_RC),length(Yr));
Vaccinated_Region=zeros(NS,length(U_Region),length(Yr));
Vaccinated_Race=zeros(NS,length(U_Race),length(Yr));
Vaccinated_Poverty=zeros(NS,length(U_Poverty),length(Yr));
Vaccinated_Mother_Education=zeros(NS,length(U_Mother_Education),length(Yr));
Vaccinated_Income_Poverty_Ratio=zeros(NS,size(U_Income_Poverty_Ratio,1),length(Yr));

Vaccinated_Race_Income_Poverty_Ratio=zeros(NS,length(U_Race),size(U_Income_Poverty_Ratio,1),length(Yr));
Vaccinated_Race_Mother_Education=zeros(NS,length(U_Race),length(U_Mother_Education),length(Yr));

Dropout_Family_Income=zeros(NS,length(U_Family_Income),length(Yr));
Dropout_Family_Income_RC=zeros(NS,length(U_Family_Income_RC),length(Yr));
Dropout_Region=zeros(NS,length(U_Region),length(Yr));
Dropout_Race=zeros(NS,length(U_Race),length(Yr));
Dropout_Poverty=zeros(NS,length(U_Poverty),length(Yr));
Dropout_Mother_Education=zeros(NS,length(U_Mother_Education),length(Yr));
Dropout_Income_Poverty_Ratio=zeros(NS,size(U_Income_Poverty_Ratio,1),length(Yr));

Dropout_Race_Income_Poverty_Ratio=zeros(NS,length(U_Race),size(U_Income_Poverty_Ratio,1),length(Yr));
Dropout_Race_Mother_Education=zeros(NS,length(U_Race),length(U_Mother_Education),length(Yr));


Two_Dose_Family_Income=zeros(NS,length(U_Family_Income),length(Yr));
Two_Dose_Family_Income_RC=zeros(NS,length(U_Family_Income_RC),length(Yr));
Two_Dose_Region=zeros(NS,length(U_Region),length(Yr));
Two_Dose_Race=zeros(NS,length(U_Race),length(Yr));
Two_Dose_Poverty=zeros(NS,length(U_Poverty),length(Yr));
Two_Dose_Mother_Education=zeros(NS,length(U_Mother_Education),length(Yr));
Two_Dose_Income_Poverty_Ratio=zeros(NS,size(U_Income_Poverty_Ratio,1),length(Yr));

Two_Dose_Race_Income_Poverty_Ratio=zeros(NS,length(U_Race),size(U_Income_Poverty_Ratio,1),length(Yr));
Two_Dose_Race_Mother_Education=zeros(NS,length(U_Race),length(U_Mother_Education),length(Yr));


rng(20250306);
for ss=1:NS
    Samp_Data=Random_Data();    
    t_dropout=strcmp(Samp_Data.Dropout,'Dropout');
    t_dropout_tot=~strcmp(Samp_Data.Dropout,'NaN');

    for uu=1:length(U_Family_Income)
        t_total=strcmp(Samp_Data.Family_Income_Bracket,U_Family_Income{uu});
        t_vac=strcmp(Samp_Data.Family_Income_Bracket,U_Family_Income{uu}) & Samp_Data.Number_of_Doses>0;
        
        t_total_2D=strcmp(Samp_Data.Family_Income_Bracket,U_Family_Income{uu}) & Samp_Data.Age>=16;
        t_vac_2D=strcmp(Samp_Data.Family_Income_Bracket,U_Family_Income{uu}) & Samp_Data.Number_of_Doses>1 & Samp_Data.Age>=16;

        for yy=1:length(Yr)
            t_year=Yr(yy)==Samp_Data.Year_Report;
            Vaccinated_Family_Income(ss,uu,yy)=sum(t_year&t_vac)./sum(t_total &t_year);
            Two_Dose_Family_Income(ss,uu,yy)=sum(t_year&t_vac_2D)./sum(t_total_2D &t_year);
            Dropout_Family_Income(ss,uu,yy)=sum(t_year & t_total & t_dropout)./sum(t_year & t_total & t_dropout_tot);
        end
    end

    for uu=1:length(U_Family_Income_RC)
        t_total=strcmp(Samp_Data.Recoded_Family_Income_Bracket,U_Family_Income_RC{uu});
        t_vac=strcmp(Samp_Data.Recoded_Family_Income_Bracket,U_Family_Income_RC{uu}) & Samp_Data.Number_of_Doses>0;
        
        t_total_2D=strcmp(Samp_Data.Recoded_Family_Income_Bracket,U_Family_Income_RC{uu}) & Samp_Data.Age>=16;
        t_vac_2D=strcmp(Samp_Data.Recoded_Family_Income_Bracket,U_Family_Income_RC{uu}) & Samp_Data.Number_of_Doses>1 & Samp_Data.Age>=16;

        for yy=1:length(Yr)
            t_year=Yr(yy)==Samp_Data.Year_Report;
            Vaccinated_Family_Income_RC(ss,uu,yy)=sum(t_year&t_vac)./sum(t_total &t_year);
            Two_Dose_Family_Income_RC(ss,uu,yy)=sum(t_year&t_vac_2D)./sum(t_total_2D &t_year);
            Dropout_Family_Income_RC(ss,uu,yy)=sum(t_year & t_total & t_dropout)./sum(t_year & t_total & t_dropout_tot);
        end
    end

    for uu=1:length(U_Race)
        t_total=strcmp(Samp_Data.Race,U_Race{uu});
        t_vac=strcmp(Samp_Data.Race,U_Race{uu}) & Samp_Data.Number_of_Doses>0;
        
        t_total_2D=strcmp(Samp_Data.Race,U_Race{uu}) & Samp_Data.Age>=16;
        t_vac_2D=strcmp(Samp_Data.Race,U_Race{uu}) & Samp_Data.Number_of_Doses>1 & Samp_Data.Age>=16;

        for yy=1:length(Yr)
            t_year=Yr(yy)==Samp_Data.Year_Report;
            Vaccinated_Race(ss,uu,yy)=sum(t_year&t_vac)./sum(t_total &t_year);
            Two_Dose_Race(ss,uu,yy)=sum(t_year&t_vac_2D)./sum(t_total_2D &t_year);
            Dropout_Race(ss,uu,yy)=sum(t_year & t_total & t_dropout)./sum(t_year & t_total & t_dropout_tot);
        end
    end

    for uu=1:length(U_Poverty)
        t_total=strcmp(Samp_Data.Poverty_Status,U_Poverty{uu});
        t_vac=strcmp(Samp_Data.Poverty_Status,U_Poverty{uu}) & Samp_Data.Number_of_Doses>0;
        
        t_total_2D=strcmp(Samp_Data.Poverty_Status,U_Poverty{uu}) & Samp_Data.Age>=16;
        t_vac_2D=strcmp(Samp_Data.Poverty_Status,U_Poverty{uu}) & Samp_Data.Number_of_Doses>1 & Samp_Data.Age>=16;

       for yy=1:length(Yr)
            t_year=Yr(yy)==Samp_Data.Year_Report;
            Vaccinated_Poverty(ss,uu,yy)=sum(t_year&t_vac)./sum(t_total &t_year);
            Two_Dose_Poverty(ss,uu,yy)=sum(t_year&t_vac_2D)./sum(t_total_2D &t_year);
            Dropout_Poverty(ss,uu,yy)=sum(t_year & t_total & t_dropout)./sum(t_year & t_total & t_dropout_tot);
        end
    end

    for uu=1:length(U_Mother_Education)
        t_total=strcmp(Samp_Data.Mother_Education,U_Mother_Education{uu});
        t_vac=strcmp(Samp_Data.Mother_Education,U_Mother_Education{uu}) & Samp_Data.Number_of_Doses>0;
        
        t_total_2D=strcmp(Samp_Data.Mother_Education,U_Mother_Education{uu}) & Samp_Data.Age>=16;
        t_vac_2D=strcmp(Samp_Data.Mother_Education,U_Mother_Education{uu}) & Samp_Data.Number_of_Doses>1 & Samp_Data.Age>=16;

       for yy=1:length(Yr)
            t_year=Yr(yy)==Samp_Data.Year_Report;
            Vaccinated_Mother_Education(ss,uu,yy)=sum(t_year&t_vac)./sum(t_total &t_year);
            Two_Dose_Mother_Education(ss,uu,yy)=sum(t_year&t_vac_2D)./sum(t_total_2D &t_year);
            Dropout_Mother_Education(ss,uu,yy)=sum(t_year & t_total & t_dropout)./sum(t_year & t_total & t_dropout_tot);
        end
    end

    for uu=1:length(U_Race)
        for pp=1:length(U_Mother_Education)
            t_total_mother_ed=strcmp(Samp_Data.Mother_Education,U_Mother_Education{pp});
            t_total=strcmp(Samp_Data.Race,U_Race{uu}) & t_total_mother_ed;
            t_vac=strcmp(Samp_Data.Race,U_Race{uu}) & Samp_Data.Number_of_Doses>0 & t_total_mother_ed;        
            
            t_total_2D=strcmp(Samp_Data.Race,U_Race{uu}) & Samp_Data.Age>=16 & t_total_mother_ed;
            t_vac_2D=strcmp(Samp_Data.Race,U_Race{uu}) & Samp_Data.Number_of_Doses>1 & Samp_Data.Age>=16 & t_total_mother_ed;

            for yy=1:length(Yr)
                t_year=Yr(yy)==Samp_Data.Year_Report;
                Vaccinated_Race_Mother_Education(ss,uu,pp,yy)=sum(t_year&t_vac)./sum(t_total &t_year);
                Two_Dose_Race_Mother_Education(ss,uu,pp,yy)=sum(t_year&t_vac_2D)./sum(t_total_2D &t_year);
                Dropout_Race_Mother_Education(ss,uu,pp,yy)=sum(t_year & t_total & t_dropout)./sum(t_year & t_total & t_dropout_tot);
            end
        end
    end

    for uu=1:length(U_Region)
        t_total=Samp_Data.Region==U_Region(uu);
        t_vac=Samp_Data.Region==U_Region(uu) & Samp_Data.Number_of_Doses>0;
        
        t_total_2D=Samp_Data.Region==U_Region(uu) & Samp_Data.Age>=16;
        t_vac_2D=Samp_Data.Region==U_Region(uu) & Samp_Data.Number_of_Doses>1 & Samp_Data.Age>=16;

       for yy=1:length(Yr)
            t_year=Yr(yy)==Samp_Data.Year_Report;
            Vaccinated_Region(ss,uu,yy)=sum(t_year&t_vac)./sum(t_total &t_year);
            Two_Dose_Region(ss,uu,yy)=sum(t_year&t_vac_2D)./sum(t_total_2D &t_year);
            Dropout_Region(ss,uu,yy)=sum(t_year & t_total & t_dropout)./sum(t_year & t_total & t_dropout_tot);
        end
    end

    for uu=1:size(U_Income_Poverty_Ratio,1)
        t_total=U_Income_Poverty_Ratio(uu,1)< Samp_Data.Income_Poverty_Ratio & Samp_Data.Income_Poverty_Ratio<=U_Income_Poverty_Ratio(uu,2);
        t_vac=U_Income_Poverty_Ratio(uu,1)< Samp_Data.Income_Poverty_Ratio & Samp_Data.Income_Poverty_Ratio<=U_Income_Poverty_Ratio(uu,2) & Samp_Data.Number_of_Doses>0;
        
        t_total_2D=U_Income_Poverty_Ratio(uu,1)< Samp_Data.Income_Poverty_Ratio & Samp_Data.Income_Poverty_Ratio<=U_Income_Poverty_Ratio(uu,2) & Samp_Data.Age>=16;
        t_vac_2D=U_Income_Poverty_Ratio(uu,1)< Samp_Data.Income_Poverty_Ratio & Samp_Data.Income_Poverty_Ratio<=U_Income_Poverty_Ratio(uu,2) & Samp_Data.Number_of_Doses>1 & Samp_Data.Age>=16;

       for yy=1:length(Yr)
            t_year=Yr(yy)==Samp_Data.Year_Report;
            Vaccinated_Income_Poverty_Ratio(ss,uu,yy)=sum(t_year&t_vac)./sum(t_total &t_year);
            Two_Dose_Income_Poverty_Ratio(ss,uu,yy)=sum(t_year&t_vac_2D)./sum(t_total_2D &t_year);
            Dropout_Income_Poverty_Ratio(ss,uu,yy)=sum(t_year & t_total & t_dropout)./sum(t_year & t_total & t_dropout_tot);
        end
    end

    for uu=1:length(U_Race)
        for pp=1:size(U_Income_Poverty_Ratio,1)
            t_poverty_total=U_Income_Poverty_Ratio(pp,1)< Samp_Data.Income_Poverty_Ratio & Samp_Data.Income_Poverty_Ratio<=U_Income_Poverty_Ratio(pp,2);
            t_total=strcmp(Samp_Data.Race,U_Race{uu}) & t_poverty_total;
            t_vac=strcmp(Samp_Data.Race,U_Race{uu}) & Samp_Data.Number_of_Doses>0 & t_poverty_total;
            
            t_total_2D=strcmp(Samp_Data.Race,U_Race{uu}) & Samp_Data.Age>=16 & t_poverty_total;
            t_vac_2D=strcmp(Samp_Data.Race,U_Race{uu}) & Samp_Data.Number_of_Doses>1 & Samp_Data.Age>=16 & t_poverty_total;

            for yy=1:length(Yr)
                t_year=Yr(yy)==Samp_Data.Year_Report;
                Vaccinated_Race_Income_Poverty_Ratio(ss,uu,pp,yy)=sum(t_year&t_vac)./sum(t_total &t_year);
                Two_Dose_Race_Income_Poverty_Ratio(ss,uu,pp,yy)=sum(t_year&t_vac_2D)./sum(t_total_2D &t_year);
                Dropout_Race_Income_Poverty_Ratio(ss,uu,pp,yy)=sum(t_year & t_total & t_dropout)./sum(t_year & t_total & t_dropout_tot);
            end
        end
    end
end

clearvars ss uu NS Samp_Data yy t_dropout  t_dropout_tot  t_total  t_vac  t_year

save('NIS_Teen_Data_Sample.mat');