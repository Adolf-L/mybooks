function threshpie(x,labels,thresh)

if nargin<3
    thresh = 0.01;
end

idx = (x > thresh);
other = sum(x(~idx));
if other > 0.1*thresh
    pie([x(idx);other],[labels(idx);'Other'])
else
    pie(x(idx),labels(idx))
end