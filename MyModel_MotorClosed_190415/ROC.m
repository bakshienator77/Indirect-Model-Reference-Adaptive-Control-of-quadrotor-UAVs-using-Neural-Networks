M=10000;
Pdtheo=zeros(1,11);
Pfatheo=zeros(1,11);
m_1=2;
m_0=1;
for i=0:10
    D=zeros(1,M);
    D2=zeros(1,M);
    T=i;
    Pdtheo(i+1)=1-poisscdf(T-1,m_1);
    Pfatheo(i+1)=1-poisscdf(T-1, m_0);
    for j=1:M
        n=poissrnd(m_1);
        n2=poissrnd(m_0);
        if(n>=T)
            D(j)=1;
        end;
        if(n2>=T)
            D2(j)=1;
        end;
        k2=sum(D2);
        k=sum(D);
        P_d(i+1)=k/M;
        P_fa(i+1)=k2/M;
    end;
end;

plot(P_fa,P_d,'r+');
hold on;
plot(Pfatheo, Pdtheo, '-*');
hold off;

%for continuous values
%P_fa = 0.1, 0.3, 0.5, 0.7
Pfa_desired=[0.1 0.3 0.5 0.7];
Pd_corresponding=zeros(1,4);
delta=ones(1,4);
index=ones(1,4);
for i=1:4
    for j=1:11
        if(Pfa_desired(i)<=P_fa(12-j))
            Pfaprime=P_fa(13-j);
            index(i)=13-j;
            Pfaprime2=P_fa(12-j);
            break;
        end;
    end;
    delta(i)=(Pfa_desired(i)-Pfaprime2)/(Pfaprime-Pfaprime2);
end;

for i=1:4
    D=zeros(1,M);
    T=index(i)-2;
    for j=1:M
        n=poissrnd(m_1);
        if(n>T)
            D(j)=1;
        elseif(n==T)
            if(rand()>delta(i))
                D(j)=1;
            end;
        end;
        k=sum(D);
        Pd_corresponding(i)=k/M;
    end;
end;

hold on
plot(Pfa_desired,Pd_corresponding,'bo');
hold off;

