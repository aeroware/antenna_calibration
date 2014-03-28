 
function PlotConceptCurrent(ant,curr,conceptcurr,seg);

% ant=PlotConceptCurrent(ant,curr,seg) plots the current distribution of
% segments seg of wire grid ant of current system curr



 deg=pi/180;

 
 %-----------------------
 % read antgrid
 %-----------------------
  
 

x=linspace(0,1);

for(n=1:length(x))
    
    if(x(n)<=ant.relbasepoints(seg,1))
        y(n)=curr(seg,1)+(conceptcurr(seg,1)-curr(seg,1))*(x(n))/(ant.relbasepoints(seg,1));
    else if(x(n)<=ant.relbasepoints(seg,2))
        y(n)=conceptcurr(seg,1)+(conceptcurr(seg,2)-conceptcurr(seg,1))*(x(n)-ant.relbasepoints(seg,1))/(ant.relbasepoints(seg,2)-ant.relbasepoints(seg,1));
    else if(x(n)<=ant.relbasepoints(seg,3))
        y(n)=conceptcurr(seg,2)+(conceptcurr(seg,3)-conceptcurr(seg,2))*(x(n)-ant.relbasepoints(seg,2))/(ant.relbasepoints(seg,3)-ant.relbasepoints(seg,2));
    else
        y(n)=conceptcurr(seg,3)+(curr(seg,2)-conceptcurr(seg,3))*(x(n)-ant.relbasepoints(seg,3))/(1-ant.relbasepoints(seg,3));
        end
        end
    end


    
end % for
 
 
 plot(x,real(y),x,imag(y));
 
 
 
 
 
 
 
 
 
