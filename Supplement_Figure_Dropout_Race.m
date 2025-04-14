clear;
clc;
close all;

load('NIS_Teen_Data_Sample.mat','Dropout_Race_Income_Poverty_Ratio','Yr','U_Race','Dropout_Race_Mother_Education','U_Mother_Education');

U_Income_Poverty_Ratio={'PIR \leq 1'; '1 < PIR \leq 2';  'PIR > 2'};
U_ME={'No College Education','Some College Education'};

C_Drop=[1 1 1;
hex2rgb('#b24745');];

U_Name={'NH White','Hispanic','NH Other/Multiple Races','NH African American'};
reorder_array=[4 1 3 2];
U_Race=U_Race(reorder_array);

figure('units','normalized','outerposition',[0.2 0.05 0.5 0.4]);
subplot('Position',[0.10 0.12 0.87 0.86]) 
Dropout_Race_Ed=zeros(4,2);
lb_drop_Ed=zeros(4,2);
ub_drop_Ed=zeros(4,2);
for uu=1:length(U_Mother_Education)
    Dropout_Race=squeeze(Dropout_Race_Mother_Education(:,:,uu,:));
    Dropout_Race=Dropout_Race(:,reorder_array,:);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
    % Summarize Dropout Data
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    Dropout=squeeze(median(Dropout_Race,1));
    lb_drop=Dropout-squeeze(prctile(Dropout_Race,25));
    ub_drop=squeeze(prctile(Dropout_Race,75))-Dropout;

    Dropout_Race_Ed(:,uu)=Dropout(:,Yr==2022);
    lb_drop_Ed(:,uu)=lb_drop(:,Yr==2022);    
    ub_drop_Ed(:,uu)=ub_drop(:,Yr==2022);    

    Year_R=Yr(:);
    Pop_Group=cell(length(Yr),length(U_Name));
    for yy=1:length(Yr)
        for xx=1:length(U_Name)
            Pop_Group{yy,xx}=[num2str(100.*Dropout(xx,yy),'%3.1f') '% (' num2str(100.*Dropout(xx,yy)-100.*lb_drop(xx,yy),'%3.1f') char(8211) num2str(100.*Dropout(xx,yy)+100.*ub_drop(xx,yy),'%3.1f') ')'];
        end
    end
    Table_Dropout=[table(Year_R) cell2table(Pop_Group)];
    Table_Dropout.Properties.VariableNames=[{'Year'};U_Name(:)]';
  

    fprintf('======================================================================================== \n');
    fprintf([ U_ME{uu} ' \n']);
    fprintf('======================================================================================== \n');
    Table_Dropout


end

C_plot_D=interp1([0 1],C_Drop,linspace(0,1,3));
% For the error bars in the bar plot
dx=[-0.125 0.125];

b=bar([1:4],100.*Dropout_Race_Ed,'LineWidth',1.5);
for ii=1:length(b)
    b(ii).FaceColor=C_plot_D(ii,:);
    b(ii).EdgeColor=C_plot_D(end,:);
end
hold on
% At Least one dose error bars
for ii=1:length(U_ME)
    errorbar(dx(ii)+[1:4],100.*Dropout_Race_Ed(:,ii),100.*lb_drop_Ed(:,ii),100.*ub_drop_Ed(:,ii),'CapSize',0,'LineStyle','none','Color',C_plot_D(end,:),'LineWidth',2);
end

set(gca,'LineWidth',2,'tickdir','out','Fontsize',14,'XTick',[1:4],'YTick',[0:10:100],'Yminortick','on','XTickLabel',U_Name);
ylabel({'Drop-out rate'},'FontSize',16)
legend(U_ME,'Fontsize',12,'NumColumns',6,'Location','northoutside');
legend boxoff;
box off;
ylim([0 60]);
xlim([0.5 4.5]);
ytickformat('percentage');
xtickangle(0)

print(gcf, ['Supplement_Figure_Race_Education.jpg'],'-djpeg','-r300');

figure('units','normalized','outerposition',[0.2 0.05 0.5 0.4]);
subplot('Position',[0.10 0.12 0.87 0.86]) 
Dropout_Race_PIR=zeros(4,2);
lb_drop_PIR=zeros(4,2);
ub_drop_PIR=zeros(4,2);

for uu=1:length(U_Income_Poverty_Ratio)
    Dropout_Race=squeeze(Dropout_Race_Income_Poverty_Ratio(:,:,uu,:));
    Dropout_Race=Dropout_Race(:,reorder_array,:);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
    % Summarize Dropout Data
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    Dropout=squeeze(median(Dropout_Race,1));
    
    lb_drop=Dropout-squeeze(prctile(Dropout_Race,25));
    ub_drop=squeeze(prctile(Dropout_Race,75))-Dropout;

    Dropout_Race_PIR(:,uu)=Dropout(:,Yr==2022);
    lb_drop_PIR(:,uu)=lb_drop(:,Yr==2022);    
    ub_drop_PIR(:,uu)=ub_drop(:,Yr==2022);    
    
    
    Year_R=Yr(:);
    Pop_Group=cell(length(Yr),length(U_Name));
    for yy=1:length(Yr)
        for xx=1:length(U_Name)
            Pop_Group{yy,xx}=[num2str(100.*Dropout(xx,yy),'%3.1f') '% (' num2str(100.*Dropout(xx,yy)-100.*lb_drop(xx,yy),'%3.1f') char(8211) num2str(100.*Dropout(xx,yy)+100.*ub_drop(xx,yy),'%3.1f') ')'];
        end
    end
    Table_Dropout=[table(Year_R) cell2table(Pop_Group)];
    Table_Dropout.Properties.VariableNames=[{'Year'};U_Name(:)]';

    fprintf('======================================================================================== \n');
    fprintf([ U_Income_Poverty_Ratio{uu} ' \n']);
    fprintf('======================================================================================== \n');
    Table_Dropout

end



C_plot_D=interp1([0 1],C_Drop,linspace(0,1,4));
% For the error bars in the bar plot
dx=[-0.225 0 0.225];

b=bar([1:4],100.*Dropout_Race_PIR,'LineWidth',1.5);
for ii=1:length(b)
    b(ii).FaceColor=C_plot_D(ii,:);
    b(ii).EdgeColor=C_plot_D(end,:);
end
hold on
% At Least one dose error bars
for ii=1:length(U_Income_Poverty_Ratio)
    errorbar(dx(ii)+[1:4],100.*Dropout_Race_PIR(:,ii),100.*lb_drop_PIR(:,ii),100.*ub_drop_PIR(:,ii),'CapSize',0,'LineStyle','none','Color',C_plot_D(end,:),'LineWidth',2);
end

set(gca,'LineWidth',2,'tickdir','out','Fontsize',14,'XTick',[1:4],'YTick',[0:10:100],'Yminortick','on','XTickLabel',U_Name);
ylabel({'Drop-out rate'},'FontSize',16)
legend(U_Income_Poverty_Ratio,'Fontsize',12,'NumColumns',6,'Location','northoutside');
legend boxoff;
box off;
ylim([0 70]);
xlim([0.5 4.5]);
ytickformat('percentage');
xtickangle(0)

print(gcf, ['Supplement_Figure_Race_PIR.jpg'],'-djpeg','-r300');