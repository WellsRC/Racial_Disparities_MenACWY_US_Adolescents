clear;
clc;
close all;

load('NIS_Teen_Data_Sample.mat','Dropout_Race_Income_Poverty_Ratio','Yr','U_Race','Dropout_Race_Mother_Education','U_Mother_Education');

U_Income_Poverty_Ratio={'PIR \leq 1'; '1 < PIR \leq 2';  'PIR > 2'};
U_ME={'No College Education','Some College Education'};

C_Drop=[hex2rgb('#fff5f0');
hex2rgb('#fee0d2');
hex2rgb('#fcbba1');
hex2rgb('#fc9272');
hex2rgb('#fb6a4a');
hex2rgb('#ef3b2c');
hex2rgb('#cb181d');
hex2rgb('#a50f15');
hex2rgb('#67000d');];
x_drop=linspace(0,1,size(C_Drop,1)-1);

U_Name={'NH White','Hispanic','NH Other + multiple races','NH African American'};
reorder_array=[4 1 3 2];
U_Race=U_Race(reorder_array);

figure('units','normalized','outerposition',[0.25 0.05 0.5 0.8]);
for uu=1:length(U_Mother_Education)
    Dropout_Race=squeeze(Dropout_Race_Mother_Education(:,:,uu,:));
    Dropout_Race=Dropout_Race(:,reorder_array,:);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
    % Summarize Dropout Data
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    Dropout=squeeze(median(Dropout_Race,1));
    
    lb_drop=Dropout-squeeze(prctile(Dropout_Race,25));
    ub_drop=squeeze(prctile(Dropout_Race,75))-Dropout;
        
    Year_R=Yr(:);
    Pop_Group=cell(length(Yr),length(U_Name));
    for yy=1:length(Yr)
        for xx=1:length(U_Name)
            Pop_Group{yy,xx}=[num2str(100.*Dropout(xx,yy),'%3.1f') '% (' num2str(100.*Dropout(xx,yy)-100.*lb_drop(xx,yy),'%3.1f') char(8211) num2str(100.*Dropout(xx,yy)+100.*ub_drop(xx,yy),'%3.1f') ')'];
        end
    end
    Table_Dropout=[table(Year_R) cell2table(Pop_Group)];
    Table_Dropout.Properties.VariableNames=[{'Year'};U_Name(:)]';

    Dropout=Dropout(:,Yr==2022);
    lb_drop=lb_drop(:,Yr==2022);
    ub_drop=ub_drop(:,Yr==2022);
    subplot('Position',[0.125 0.6-0.5.*(uu-1) 0.87 0.38]) 
    b=bar([1:4],100.*Dropout,'LineWidth',1.5);
    b.FaceColor=C_Drop(end-3,:);
    b.EdgeColor=C_Drop(end,:);
   
    hold on
    errorbar([1:4],100.*Dropout,100.*lb_drop,100.*ub_drop,'CapSize',0,'LineStyle','none','Color',C_Drop(end,:),'LineWidth',2);
    % end
    
    
    set(gca,'LineWidth',2,'tickdir','out','Fontsize',14,'XTick',[1:4],'YTick',[0:10:100],'Yminortick','on','XTickLabel',U_Name);
    xlabel('Population group','FontSize',16)
    ylabel({'Drop-out rate'},'FontSize',16)
    box off;
    xtickangle(0)
    xlim([0.5 4.5])
    ylim([0 60]);
    ytickformat('percentage');
    text(-0.125,1,char(64+uu),'Units','normalized','HorizontalAlignment','center','VerticalAlignment','middle','Fontsize',28);


    

    fprintf('======================================================================================== \n');
    fprintf([ U_ME{uu} ' \n']);
    fprintf('======================================================================================== \n');
    Table_Dropout


end

exportgraphics(gcf, ['Supplement_Figure_2.pdf']);
print(gcf, ['Supplement_Figure_2.jpg'],'-djpeg','-r300');

figure('units','normalized','outerposition',[0.25 0.05 0.5 0.8]);
for uu=1:length(U_Income_Poverty_Ratio)
    Dropout_Race=squeeze(Dropout_Race_Income_Poverty_Ratio(:,:,uu,:));
    Dropout_Race=Dropout_Race(:,reorder_array,:);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
    % Summarize Dropout Data
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    Dropout=squeeze(median(Dropout_Race,1));
    
    lb_drop=Dropout-squeeze(prctile(Dropout_Race,25));
    ub_drop=squeeze(prctile(Dropout_Race,75))-Dropout;
    
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


    Dropout=Dropout(:,Yr==2022);
    lb_drop=lb_drop(:,Yr==2022);
    ub_drop=ub_drop(:,Yr==2022);
    subplot('Position',[0.125 0.75-0.33.*(uu-1) 0.87 0.23]) 
    b=bar([1:4],100.*Dropout,'LineWidth',1.5);
    b.FaceColor=C_Drop(end-3,:);
    b.EdgeColor=C_Drop(end,:);
   
    hold on
    errorbar([1:4],100.*Dropout,100.*lb_drop,100.*ub_drop,'CapSize',0,'LineStyle','none','Color',C_Drop(end,:),'LineWidth',2);
    % end
    
    
    set(gca,'LineWidth',2,'tickdir','out','Fontsize',14,'XTick',[1:4],'YTick',[0:10:100],'Yminortick','on','XTickLabel',U_Name);
    xlabel('Population group','FontSize',16)
    ylabel({'Drop-out rate'},'FontSize',16)
    box off;
    xtickangle(0)
    xlim([0.5 4.5])
    ylim([0 70]);
    ytickformat('percentage');
    text(-0.125,1,char(64+uu),'Units','normalized','HorizontalAlignment','center','VerticalAlignment','middle','Fontsize',28);


end
exportgraphics(gcf, ['Supplement_Figure_3.pdf']);
print(gcf, ['Supplement_Figure_3.jpg'],'-djpeg','-r300');