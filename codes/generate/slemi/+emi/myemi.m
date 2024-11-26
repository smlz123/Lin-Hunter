%--myemi--
%--------Only Responsible For Mass Production of Verilog Design--------%
%---In a round, 10 seeds are generated and 50 variants are mutanted----%
%-------------------------------Config---------------------------------%
futherFolderPath = 'D:\zgl\gen';%<--tool position
ROUND_MAX = 1000;                     %<--execution times
%---------------------------Relative PATH------------------------------%
sgtestFolderPath = [futherFolderPath,'\slsf_randgen\slsf\sgtest'];
reportsneo_folderPath = [futherFolderPath,'\slsf_randgen\slsf\reportsneo'];

seedFolderPath = [futherFolderPath,'\slemi\reproduce\samplecorpus'];
emiresults_folderPath = [futherFolderPath,'\slemi\emi_results'];

HDLsrc_folderPath = [futherFolderPath,'\Verilog_hdlsrc'];
setenv('SLSFCORPUS',seedFolderPath);
setenv('COVEXPEXPLORE',seedFolderPath);
%-------------------------------MAIN-----------------------------------%
for round = 1: ROUND_MAX
    % contorl SLForge
    run(sgtestFolderPath);

    % copyfile
    slsf_stmp = Get_file_name(reportsneo_folderPath);
    slsf_stmp = slsf_stmp{length(slsf_stmp)};
    slsfSuccess_folderPath = [reportsneo_folderPath,'\',slsf_stmp,'\','success'];

    rmdir(seedFolderPath,'s');
    mkdir(seedFolderPath);
    success_seed_num = length(dir(fullfile(slsfSuccess_folderPath,'*.slx')));
    if success_seed_num
        movefile(fullfile(slsfSuccess_folderPath,'*.slx'),seedFolderPath);
        rmdir([reportsneo_folderPath,'\',slsf_stmp],'s');  
    else
        disp('****no seed was successfully generated at current ronud****');
        rmdir([reportsneo_folderPath,'\',slsf_stmp],'s');
        continue;
    end
    % contorl SLEMI
    NUM_MAINLOOP_ITER = 5 * success_seed_num;
    save ('NUM_MAINLOOP_ITER.mat','NUM_MAINLOOP_ITER');
    covexp.covcollect;
    try
        disp('### SLEMI running begin')
        emi.go
    catch e
        disp(e)
    end

    emi_stmp = Get_file_name(emiresults_folderPath);
    emi_stmp = emi_stmp{length(emi_stmp)};
    EMI_folderPath = [emiresults_folderPath,'\',emi_stmp];

    % merge and classify emi results
    mergeFolders(EMI_folderPath,seedFolderPath);
    result = classify_mergemodels(EMI_folderPath);

    % HDL Generation
    for i = 1:length(result)
        crtSampleModelPath = char(result(i));
        Slx_list = Get_file_name(crtSampleModelPath);
        model_init(crtSampleModelPath);%model init
        hdl_generate(Slx_list,crtSampleModelPath,crtSampleModelPath);%hdl generate
        % complexity = getModelComplexity(result(i));%calculate complexity
        submit_verilog(result(i),HDLsrc_folderPath);
    end

    emi.remote(EMI_folderPath);
end

%----------------------------FUNCTION-------------------------------%
function ret = Get_file_name(dirroad)
    dirInfo = dir(dirroad);
    fileNames = {};
    for i = 1:length(dirInfo)
        if ~strcmp(dirInfo(i).name, '.') && ~strcmp(dirInfo(i).name, '..')
            fileNames{end+1} = dirInfo(i).name;
        end
    end

    % disp('文件名列表：');
    disp(fileNames);
    ret = fileNames;
end

function mergeFolders(folderPath,seedFolderPath)

    mergedFolder = fullfile(folderPath,'merged');
    if ~exist("mergedFolder","dir")
        mkdir(mergedFolder);
    end

    folders = dir(folderPath);
    folders = folders([folders.isdir]);

    for i = 1:length(folders)
        if ~strcmp(folders(i).name,'.') && ~strcmp(folders(i).name,'..')
            %merge begin
            sourceFolder = fullfile(folderPath,folders(i).name);
            if ~strcmp(sourceFolder,mergedFolder)
                files = dir(fullfile(sourceFolder,'*.slx'));
                not_diff_files = files(~cellfun(@isempty,regexp({files.name},'\d\.slx$')));
                for j = 1:length(not_diff_files)
                    sourceFile = fullfile(sourceFolder,not_diff_files(j).name);
                    destFile = fullfile(mergedFolder,not_diff_files(j).name);
                    movefile(sourceFile,destFile);
                end
            end
        end
    end

    seed_files = dir(fullfile(seedFolderPath,'*_pp.slx'));
    for i = 1:length(seed_files)
        sourceFile = fullfile(seedFolderPath,seed_files(i).name);
        destFile = fullfile(mergedFolder,seed_files(i).name);
        movefile(sourceFile,destFile);
    end
end

function result = classify_mergemodels(folderPath)
    Digit = [];
    emergedfolderPath = [folderPath,'\','merged'];
    files = dir(fullfile(emergedfolderPath,'*.slx'));

    for i = 1:length(files)
        [~, fileName, ~] = fileparts(files(i).name);%get files name
        NumIndex = regexp(fileName,'Model(\d+)','match');
        NumIndex = NumIndex{1};
        NumIndex = NumIndex(6:end);
        categoryFolder = fullfile(folderPath,strcat('SampleModel', NumIndex));
        NumIndex = str2double(NumIndex);
        Digit = [Digit,NumIndex];
        if ~exist("categoryFolder","dir")
            mkdir(categoryFolder);
        end

        sourcefiles = fullfile(emergedfolderPath,files(i).name);
        destfiles = fullfile(categoryFolder,files(i).name);
        movefile(sourcefiles,destfiles);
    end
    Digit = unique(Digit);
    result = [];
    for j = 1:length(Digit)
        result = [result,string(folderPath)+'\'+'SampleModel'+string(Digit(j))];
    end
end

function complexity = getModelComplexity(SampleModelFolderPath)
    SampleModelFiles = dir(fullfile(SampleModelFolderPath,'*1.slx'));
    oriSampleModelFiles = dir(fullfile(SampleModelFolderPath,'*p.slx'));
    num = sum(arrayfun(@(x) isfield(x,'name'),SampleModelFiles));
    SampleModelFiles(num+1).name  = oriSampleModelFiles(1).name;

    % txtPath = [SampleModelFolderPath+'\'+'ComplexityRresult'];
    % mkdir(txtPath);
    for m = 1:length(SampleModelFiles)
        SamplemodelFilePath = fullfile(SampleModelFolderPath,SampleModelFiles(m).name); 
        load_system(SamplemodelFilePath);
        crtModel = gcs;
        blocks = find_system(crtModel,'findAll','on','Type','Block');
        lines = find_system(crtModel,'findAll','on','Type','Line');
        numblocks = length(blocks);
        numlines = length(lines);
        complexity = numblocks*0.5 + numlines*0.5;
        % name = SampleModelFiles(m).name(1:length(SampleModelFiles(m).name)-4);
        % txtID = fopen([txtPath+'\'+name+'.txt'],'w');
        % fprintf(txtID,'%.2f\n',complexity);
        % fclose(txtID);
        close_system(crtModel,0);
    end
end

function submit_verilog(SampleModelFolderPath,destPath)
    hdlPath = [SampleModelFolderPath+'\Verilog_hdlsrc'];
    subfolders = dir(hdlPath);
    subfolders = subfolders([subfolders.isdir]);
    max_files_count = 0;
    ori_files_count = 0;
    max_folder_path = '';
    ori_Folder_path =  '';
    for i = 1:length(subfolders)
        folder_name = subfolders(i).name;
        if strcmp(folder_name,'.') || strcmp(folder_name,'..')
            continue;
        end
        if contains(folder_name,'pp_sub')
            ori_Folder_path = fullfile(hdlPath,folder_name);
            ori_files = dir(fullfile(ori_Folder_path,'*.v'));
            ori_files_count = length(ori_files);
        end
        subfolders_path = fullfile(hdlPath,folder_name);
        
        files = dir(fullfile(subfolders_path,'*.v'));
        files_count = length(files);
        if files_count > max_files_count
            max_files_count = files_count;
            max_folder_path = subfolders_path;
        end
    end
    if max_files_count ~= ori_files_count
        if ~strcmp(ori_Folder_path,max_folder_path)
            mkdir(destPath);
            movefile(ori_Folder_path,destPath,'f');
            movefile(max_folder_path,destPath,'f');
        end
    end
end

function model_init(model_path)
    modelFiles = dir(fullfile(model_path,'*.slx'));

    for i = 1:length(modelFiles)
        modelFilePath = fullfile(model_path,modelFiles(i).name);
        open_system(modelFilePath);
        modelName = gcs;
        topLevelBlocks = find_system(modelName,'SearchDepth',2,'Type','Block');
        emiBlocks = find_system(modelName,'BlockType','If');
        delayBlocks = find_system(modelName,'BlockType','Delay');
        relationBlocks = find_system(modelName,'BlockType','RelationalOperator');
        % subSystemBlocks = find_system(modelName,'BlockType','SubSystem');
        % compareBlocks = find_system(subSystemBlocks,'BlockType','RelationalOperator');
        % name = get_param('sampleModel548_pp_3_1/cfblk5/cfblk5','BlockType');

        for j = 1:length(topLevelBlocks)
            set_value(topLevelBlocks{j});% process Outport BLOCK
        end

        for m = 1:length(emiBlocks)
            crt_emiBlock = emiBlocks{m};
            ifexpression = get_param(crt_emiBlock,'IfExpression');
            ifexpression = str2num(ifexpression(1:end-6));
            if ifexpression>255
               set_param(crt_emiBlock,'IfExpression','255 <= u1')%process If BLOCK
            elseif ifexpression<0
               set_param(crt_emiBlock,'IfExpression','0 <= u1')%process If BLOCK
            end
        end

        for n = 1:length(delayBlocks)
            crt_delayBlock = delayBlocks{n};
            init_condition_source = get_param(crt_delayBlock,'InitialCondition');
            init_condition_source = str2num(init_condition_source);
            if init_condition_source>255
               set_param(crt_delayBlock,'InitialCondition','255')%process Delay BLOCK
            elseif init_condition_source<0
               set_param(crt_delayBlock,'InitialCondition','0')%process Delay BLOCK
            end
        end

        for q = 1:length(relationBlocks)
            crt_relationBlocks = relationBlocks{q};
            set_param(crt_relationBlocks,'OutDataTypeStr','''uint8''');
        end

        save_system(modelFilePath);
        close_system(modelFilePath);
    end
    function set_value(blockPath)
        OutputChildern = find_system(blockPath,'SearchDepth',1,'BlockType','Outport');
        CompareChildern = find_system(blockPath,'SearchDepth',1,'BlockType','SubSystem');
        for k = 1:length(OutputChildern)
                crt_childern = OutputChildern{k};
                set_param(crt_childern,'InitialOutput','[0]');
        end

        for p = 1:length(CompareChildern)
            crt_compareChildern = CompareChildern{p};
            try 
                data_type = get_param(crt_compareChildern,'OutDataTypeStr');
            catch
                disp('****current block is not Compare To Zero****');
                continue;
            end
            if ~isempty(data_type)
                set_param(crt_compareChildern,'OutDataTypeStr','uint8');
            end
        end
    end        
end

function ret = hdl_generate(Slx_list,Hdl_savePath,Hdl_folderPath)
    for i = 1:length(Slx_list)
        modelpath = [Hdl_folderPath,'\',Slx_list{i}];
        h =load_system(modelpath);
        %set_param(h,'Check for presence of reals in generated HDL code','None');
        [token, remaining] = strtok(Slx_list{i}, '.');
        prefix = strrep(token, '.', '');
        disp(prefix);
        disp('**While loading simulink model to check it will take some time**');
        try
            outBlocks = find_system(h, 'BlockType', 'Outport');
            if isempty(outBlocks)
                b=Simulink.findBlocks(h);
                randomInteger = randi(length(b));
                out_handle = add_block('simulink/ Sinks/ Out1',[prefix,'/','Hdl_out']);
                add_line(h,out_handle,b{randomInteger});
            end
            b=Simulink.findBlocks(h);
            randomInteger = randi(length(b));
            out_handle = add_block('simulink/Sinks/Out1',[prefix,'/','Hdl_out']);
            out_port_handle = get_param(out_handle,'PortHandles');
            out_port_handle = out_port_handle.Inport;
            outputPortHandle = get_param(b(randomInteger), 'PortHandles');
            outputPortHandle = outputPortHandle.Outport;
            if ~isempty(outputPortHandle)
                add_line(h,outputPortHandle(1),out_port_handle);
            else
                disp('**recheck and choose**')
                for i = 1:length(b)
                    outputPortHandle = get_param(b(i), 'PortHandles');
                    outputPortHandle = outputPortHandle.Outport;
                    if isempty(outputPortHandle)
                    else
                        add_line(h,outputPortHandle(1),out_port_handle);
                        break;
                    end
                end
            end
        catch
            disp('no need to add anything')
        end

        % HDL Code generation%%
        % before hdl generation to generate stimuli files create a subsystem
        %slicedStrings = split(Slx_list{i}, '.');
        save_system(prefix);
        is_changed = change_modelDataTypeStr(prefix);
        if is_changed == 1
            disp('All has changed')
        else
            disp('there are some errors')
        end
        load_system(prefix);
        sub_Stimuli_model_name = [prefix,'_sub'];
        new_system(sub_Stimuli_model_name);
        sub_str_arry = [sub_Stimuli_model_name,'/Subsystem'];
        add_block('built-in/Subsystem',sub_str_arry)
        Simulink.BlockDiagram.copyContentsToSubsystem...
            (h,sub_str_arry);
        model_save_path = [Hdl_folderPath,'\',sub_Stimuli_model_name,'.slx'];
        save_system(sub_Stimuli_model_name,model_save_path);
        disp('***save sucessful, next step is generate hdl code, please attention target language***')
        load_system(sub_Stimuli_model_name);
        try
            % Use hdlset_param to set the parameter on the model.
            hdlset_param(sub_Stimuli_model_name,'TreatRealsInGeneratedCodeAs','Warning')
            Hdl_src_path = [Hdl_savePath,'\','Verilog','_','hdlsrc'];
            if ~exist(Hdl_src_path, 'dir')
                mkdir(Hdl_src_path);
                disp(['floder ', Hdl_src_path, ' do not exist, creating it.']);
            else
                disp(['folder ', Hdl_src_path, ' has been existed.']);
            end
            makehdl(sub_str_arry, 'TargetLanguage', 'Verilog','TargetDirectory',Hdl_src_path)
            %把计算结果放到Hdl_src_path
        catch e
            disp('***** there are some errors *****')
            disp(e)
        end
        try
            %generate stimuli file
            makehdltb(sub_str_arry,'TargetLanguage','Verilog',...
                'UseFileIOInTestBench','off','TargetDirectory',Hdl_src_path);
        catch e
            disp('***** there are some errors in generating testbench*****')
        end
        disp('**close_system and save**')
        save_system(sub_Stimuli_model_name);
        close_system(sub_Stimuli_model_name);
        close_system(prefix);
    end
end
