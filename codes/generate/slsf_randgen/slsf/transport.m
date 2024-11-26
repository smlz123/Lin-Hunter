function transport()
    % 设置路径
    base_path = 'E:\FPGA\firstversion\COMBAT-master\COMBAT-master\emi_results';
    destination_base_path = 'E:\FPGA\firstversion\generate\slsf_randgen\slsf\reportsneo';

    % 获取当前日期时间
    current_datetime = datetime('now', 'Format', 'yyyy-MM-dd-HH-mm');
    current_date_str = datestr(current_datetime, 'yyyy-mm-dd-HH-MM');
    
    % 获取所有子文件夹
    all_subfolders = dir(base_path);
    all_subfolders = all_subfolders([all_subfolders.isdir]); % 只保留文件夹
    all_subfolders = all_subfolders(~ismember({all_subfolders.name}, {'.', '..'})); % 去除 . 和 ..

    % 查找距离当前日期最近的文件夹
    min_date_diff = inf;
    closest_folder = '';
    for k = 1:length(all_subfolders)
        folder_datetime = datetime(all_subfolders(k).date, 'InputFormat', 'dd-MMM-yyyy HH:mm:ss');
        date_diff = abs(current_datetime - folder_datetime);
        if date_diff < min_date_diff
            min_date_diff = date_diff;
            closest_folder = all_subfolders(k).name;
        end
    end
    
    if isempty(closest_folder)
        error('No subfolder found in the specified path.');
    end
    
    % 构建最近文件夹的路径
    closest_folder_path = fullfile(base_path, closest_folder);

    % 获取最近文件夹中的所有子文件夹
    subfolders_in_closest_folder = dir(closest_folder_path);
    subfolders_in_closest_folder = subfolders_in_closest_folder([subfolders_in_closest_folder.isdir]); % 只保留文件夹
    subfolders_in_closest_folder = subfolders_in_closest_folder(~ismember({subfolders_in_closest_folder.name}, {'.', '..'})); % 去除 . 和 ..

    % 创建目的路径中的新文件夹
    new_destination_folder = fullfile(destination_base_path, current_date_str);
    if ~exist(new_destination_folder, 'dir')
        mkdir(new_destination_folder);
    end

    % 遍历子文件夹并复制pp.slx文件
    for k = 1:length(subfolders_in_closest_folder)
        subfolder_path = fullfile(closest_folder_path, subfolders_in_closest_folder(k).name);
        pp_files = dir(fullfile(subfolder_path, '*pp.slx'));
        
        for j = 1:length(pp_files)
            source_file = fullfile(subfolder_path, pp_files(j).name);
            destination_file = fullfile(new_destination_folder, pp_files(j).name);
            copyfile(source_file, destination_file);
        end
    end
    
    disp('Files copied successfully.');
end
