%---------------------------------
%
% rlistcoefdaub.m
%
% 25/08/95
% P. Abry
%
%
% remplit h avec la liste des hn 
% de Daubechies
%-------------------------------------

function h=rlistcoefdaud(regu);

if ~(regu<11 & regu>0),
	mess=[' Ondelette non implantee'];
	disp(mess);
	return;
else
	if regu==1,
   h=[1/sqrt(2) 1/sqrt(2)];
 %  g=[1/sqrt(2) -1/sqrt(2)];
end
if regu==2,
   h(1:2)=[0.482962913145 0.836516303738];
   h(3:4)=[0.224143868042 -0.129409522551];
end
if regu==3,
   h(1:2)=[0.332670552950 0.806891509311];
   h(3:4)=[0.459877502118 -0.135011020010];
   h(5:6)=[-0.085441273882 0.035226291882];
end
if regu==4,
   h(1:2)=[0.230377813309 0.714846570553];
   h(3:4)=[0.630880767930 -0.027983769417];
   h(5:6)=[-0.187034811719 0.030841381836];
   h(7:8)=[0.032883011667 -0.010597401785];
end
if regu==5,
   h(1:2)=[0.160102397974 0.603829269797];
   h(3:4)=[0.724308528438 0.138428145901];
   h(5:6)=[-0.242294887066 -0.032244869585];
   h(7:8)=[0.077571493840 -0.006241490213];
   h(9:10)=[-0.012580751999 0.003335725285];
end
if regu==6,
   h(1:2)=[0.111540743350 0.494623890398];
   h(3:4)=[0.751133908021 0.315250351709];
   h(5:6)=[-0.226264693965 -0.129766867567];
   h(7:8)=[0.097501605587 0.027522865530];
   h(9:10)=[-0.031582039318 0.000553842201];
   h(11:12)=[0.004777257511 -0.001077301085];
end
if regu==7,
   h(1:2)=[0.077852054085 0.396539319482];
   h(3:4)=[0.729132090846 0.469782287405];
   h(5:6)=[-0.143906003929 -0.224036184994];
   h(7:8)=[0.071309219267 0.080612609151];
   h(9:10)=[-0.038029936935 -0.016574541631];
   h(11:12)=[0.012550998556 0.000429577973];
   h(13:14)=[-0.001801640704 0.000353713800];
end
if regu==8,
   h(1:2)=[0.054415842243 0.312871590914];
   h(3:4)=[0.675630736297 0.585354683654];
   h(5:6)=[-0.015829105256 -0.284015542962];
   h(7:8)=[0.000472484574 0.128747426620];
   h(9:10)=[-0.017369301002 -0.044088253931];
   h(11:12)=[0.013981027917 0.008746094047];
   h(13:14)=[-0.004870352993 -0.000391740373];
   h(15:16)=[0.000675449406 -0.000117476784];
end
if regu==9,
   h(1:2)=[0.038077947364 0.243834674613];
   h(3:4)=[0.604823123690 0.657288078051];
   h(5:6)=[0.133197385825 -0.293273783279];
   h(7:8)=[-0.096840783223 0.148540749338];
   h(9:10)=[0.030725681479 -0.067632829061];
   h(11:12)=[0.000250947115 0.022361662124];
   h(13:14)=[-0.004723204758 -0.004281503682];
   h(15:16)=[0.001847646883 0.000230385764];
   h(17:18)=[-0.000251963189 0.000039347320];
end
if regu==10,
   h(1:2)=[0.026670057901 0.188176800078];
   h(3:4)=[0.52720118932 0.688459039454];
   h(5:6)=[0.281172343661 -0.249846424327];
   h(7:8)=[-0.195946274377 0.127369340336];
   h(9:10)=[0.093057364604 -0.071394147166];
   h(11:12)=[-0.029457536822 0.033212674059];
   h(13:14)=[0.003606553567 -0.010733175483];
   h(15:16)=[0.001395351747 0.001992405295];
   h(17:18)=[-0.000685856695 -0.000116466855];
   h(19:20)=[0.000093588670 -0.000013264203];
end
end

