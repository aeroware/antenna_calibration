function [q]=TestMex

q=0;
for a= 1:1000
    for b=1:1000
        q=q+a+b;
    end
end
