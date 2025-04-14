clear;
clc;

load('State_Regional_Number.mat');

County = shaperead([pwd '\Shapefile\cb_2021_us_county_500k.shp'], 'UseGeoCoords', true);
poly_region=cell(10,1);
for rn=1:10
    find_state=find([Regional_Number{:,2}]==rn);
    poly_temp=polyshape();
    for ss=1:length(find_state)
        find_countys=find(strcmpi({County.STATE_NAME},Regional_Number{find_state(ss),1}));
        for cc=1:length(find_countys)
            poly_temp=union(poly_temp,polyshape(County(find_countys(cc)).Lat,County(find_countys(cc)).Lon,'Simplify',false));
        end
    end
    s= rmholes(poly_temp);
    s = rmslivers(s,10.^(-4));
    poly_temp = geoshape(s.Vertices(:,1), s.Vertices(:,2));
    poly_region{rn}=poly_temp;
end

save('HHS_Region_Polygons.mat',"poly_region")