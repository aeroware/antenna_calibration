function [q]=TestMex3

q=0;
for a= 1:1000
    for b=1:10000
        q=q+a+b;
    end
end
