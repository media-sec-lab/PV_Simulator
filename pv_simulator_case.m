function pv_simulator_case(p,case_i,start_index,end_index)
% %By: Qin Xinghong.
% %Date: 2017.04.19
% %Make image sets for verifying Condition security of PV.
% %p: payload
% %Change1: Condition#1.
% %Change2: Condition#2.
% %Change3: Condition#3.

    image_path='/home/qinxinghong/Result/Color/BOSSBase/PV/PV_Case';
    
    s_names={'P1','P2','P3','P1P2','P1P3','P2P3','P1M2P3','P1P2M3','P1P2P3'};
    for i=1:3
        if case_i~=0 && case_i~=i continue; end
        t_dir=sprintf('%s%sC%d',image_path,filesep,i);
        if exist(t_dir,'dir')==0
            mkdir(t_dir);
        end
        
        for p_s=p
            p_u=uint8(p_s*100);
            for j=1:length(s_names)
                t_dir=sprintf('%s%sS%d_%s_p%03d',image_path,filesep,i,s_names{j}, p_u);
                if exist(t_dir,'dir')==0
                    mkdir(t_dir);
                end
            end
        end
    end
        
    s1=256;s2=256;
    if start_index<=0
        start_index=1;
    end
    if end_index<=start_index
        end_index=4000;
    end
    
    parfor j=start_index:end_index %1:4000
        fprintf('PV, index: %d...\r\n',j);
        if case_i==0 || case_i==1
            make_case1(j,p,image_path,s1,s2); 
        end
        if case_i==0 || case_i==2 
            make_case2(j,p,image_path,s1,s2); 
        end
        if case_i==0 || case_i==3 
            make_case3(j,p,image_path,s1,s2);
        end
    end
    
    fprintf('------------Finished.---------------\r\n');
end

function make_case1(i_ppm,p,img_dir,s1,s2)
% %Rule: x3>=2x2.    
% %Size: s1*s2*3

    m=s1*s2;
    X=zeros(m,3);
    X_3=randi([64,254],m,1);
    X(:,3)=X_3;
    X_2=floor(0.5.*X_3);
    for i=1:m
        X_2(i)=randi([2,X_2(i)],1);
    end
    X(:,2)=X_2;
    X_1=X_2;%-1;
    for i=1:m
        X_1(i)=randi(X_1(i),1);
    end
    X(:,1)=X_1;
    
    I_x=X;
    Y=X;
    for i=1:m
       I_x(i,:)=randperm(3); 
       Y(i,:)=X(i,I_x(i,:));
    end
    
    t_file=sprintf('%s%sC1%s%d.ppm',img_dir,filesep,filesep,i_ppm);
    imwrite(uint8(reshape(Y,s1,s2,3)),t_file);
    
    s_names={'P1','P2','P3','P1P2','P1P3','P2P3','P1P2M3','P1M2P3','P1P2P3'};
    Y_s=cell(1,9);
    for p_s=p
        for i=1:9
            Y_s{i}=X;
        end
        n_sel=ceil(m*p_s);
        i_sel=randperm(m,n_sel);
        
        for i=1:3
            Y_s{i}(i_sel,i)=X(i_sel,i)+1;
        end
        Y_s{4}(i_sel,1:2)=X(i_sel,1:2)+1;
        Y_s{5}(i_sel,1)=X(i_sel,1)+1;
        Y_s{5}(i_sel,3)=X(i_sel,3)+1;
        Y_s{6}(i_sel,2:3)=X(i_sel,2:3)+1;
        Y_s{7}=Y_s{4};
        Y_s{7}(i_sel,3)=X(i_sel,3)-1;
        Y_s{8}=Y_s{5};
        Y_s{8}(i_sel,2)=X(i_sel,2)-1;
        Y_s{9}(i_sel,:)=X(i_sel,:)+1;
        
        p_u=uint8(p_s*100);
        for i=1:9
            Y=Y_s{i};
            for j=1:m
                Y(j,:)=Y_s{i}(j,I_x(j,:));
            end
            t_file=sprintf('%s%sS1_%s_p%03d%s%d.ppm',img_dir,filesep,s_names{i},p_u,filesep,i_ppm);
            imwrite(uint8(reshape(Y,s1,s2,3)),t_file);
        end
    end
end

function make_case2(i_ppm,p,img_dir,s1,s2)
% %Rule: 2x2>=x1+x3 & x2>=2x1.    
% %Size: s1*s2*3

    m=s1*s2;
    X=zeros(m,3);
    X_1=randi([1,64],m,1); 
    X(:,1)=X_1;
    X_12=2.*X_1;
    X_2=X_12;
    for i=1:m
        X_2(i)=randi([X_2(i),252],1);
    end
    X(:,2)=X_2;
    X_3=2.*X_2-X_1;
    for i=1:m
        X_3(i)=randi([X_2(i),min(254,X_3(i))],1);
    end
    X(:,3)=X_3;
    
    I_x=X;
    Y=X;
    for i=1:m
       I_x(i,:)=randperm(3); 
       Y(i,:)=X(i,I_x(i,:));
    end
    
    t_file=sprintf('%s%sC2%s%d.ppm',img_dir,filesep,filesep,i_ppm);
    imwrite(uint8(reshape(Y,s1,s2,3)),t_file);
    
    s_names={'P1','P2','P3','P1P2','P1P3','P2P3','P1P2M3','P1M2P3','P1P2P3'};
    Y_s=cell(1,9);
    for p_s=p
        for i=1:9
            Y_s{i}=X;
        end
        n_sel=ceil(m*p_s);
        i_sel=randperm(m,n_sel);
        
        for i=1:3
            Y_s{i}(i_sel,i)=X(i_sel,i)+1;
        end
        Y_s{4}(i_sel,1:2)=X(i_sel,1:2)+1;
        Y_s{5}(i_sel,1)=X(i_sel,1)+1;
        Y_s{5}(i_sel,3)=X(i_sel,3)+1;
        Y_s{6}(i_sel,2:3)=X(i_sel,2:3)+1;
        Y_s{7}=Y_s{4};
        Y_s{7}(i_sel,3)=X(i_sel,3)-1;
        Y_s{8}=Y_s{5};
        Y_s{8}(i_sel,2)=X(i_sel,2)-1;
        Y_s{9}(i_sel,:)=X(i_sel,:)+1;
        
        p_u=uint8(p_s*100);
        for i=1:9
            Y=Y_s{i};
            for j=1:m
                Y(j,:)=Y_s{i}(j,I_x(j,:));
            end
            t_file=sprintf('%s%sS2_%s_p%03d%s%d.ppm',img_dir,filesep,s_names{i},p_u,filesep,i_ppm);
            imwrite(uint8(reshape(Y,s1,s2,3)),t_file);
        end
    end
end

function make_case3(i_ppm,p,img_dir,s1,s2)
% %Rule: 2x1>=x3.    
% %Size: s1*s2*3
    m=s1*s2;
    X=zeros(m,3);
    X_3=randi([2,254],m,1);
    X(:,3)=X_3;
    X_1=ceil(0.5.*X_3);
    X_3=X_3-1;
    for i=1:m
        X_1(i)=randi([X_1(i),X_3(i)],1);
    end
    X(:,1)=X_1;
    X_2=X_1;
    for i=1:m
        X_2(i)=randi([X_2(i),X_3(i)],1);
    end
    X(:,2)=X_2;
    
    I_x=X;
    Y=X;
    for i=1:m
       I_x(i,:)=randperm(3); 
       Y(i,:)=X(i,I_x(i,:));
    end
    
    t_file=sprintf('%s%sC3%s%d.ppm',img_dir,filesep,filesep,i_ppm);
    imwrite(uint8(reshape(Y,s1,s2,3)),t_file);
    
    s_names={'P1','P2','P3','P1P2','P1P3','P2P3','P1P2M3','P1M2P3','P1P2P3'};
    Y_s=cell(1,9);
    for p_s=p
        for i=1:9
            Y_s{i}=X;
        end
        n_sel=ceil(m*p_s);
        i_sel=randperm(m,n_sel);
        
        for i=1:3
            Y_s{i}(i_sel,i)=X(i_sel,i)+1;
        end
        Y_s{4}(i_sel,1:2)=X(i_sel,1:2)+1;
        Y_s{5}(i_sel,1)=X(i_sel,1)+1;
        Y_s{5}(i_sel,3)=X(i_sel,3)+1;
        Y_s{6}(i_sel,2:3)=X(i_sel,2:3)+1;
        Y_s{7}=Y_s{4};
        Y_s{7}(i_sel,3)=X(i_sel,3)-1;
        Y_s{8}=Y_s{5};
        Y_s{8}(i_sel,2)=X(i_sel,2)-1;
        Y_s{9}(i_sel,:)=X(i_sel,:)+1;
        
        p_u=uint8(p_s*100);
        for i=1:9
            Y=Y_s{i};
            for j=1:m
                Y(j,:)=Y_s{i}(j,I_x(j,:));
            end
            t_file=sprintf('%s%sS3_%s_p%03d%s%d.ppm',img_dir,filesep,s_names{i},p_u,filesep,i_ppm);
            imwrite(uint8(reshape(Y,s1,s2,3)),t_file);
        end
    end
end
