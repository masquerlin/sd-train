import os
import json
from pathlib import Path

def create_metadata_and_rename(folder_path):
    # 获取文件夹中的所有图片文件
    image_files = [f for f in os.listdir(folder_path) if f.lower().endswith(('.png', '.jpg', '.jpeg', '.gif'))]
    
    metadata = []
    
    for i, old_filename in enumerate(image_files, start=1):
        # 构造新的文件名
        new_filename = f"{i:04d}{Path(old_filename).suffix}"
        
        # 从原文件名中提取描述文本
        text = Path(old_filename).stem
        
        # 创建 JSON 对象
        metadata_item = {
            "file_name": new_filename,
            "text": "Mazda, Rx7, retro futurism, JDM, body knits , minimalism, mecha, negative space, sleek, front bumper, air intake, engine hood, fender, headlight, fog lamp, low beam, high beam, side skirt, HUD futuristic, carbon fiber, rim, grille, side panel, front panel, wheel arch, rear bumper, rear wing, exhaust outlet,"
        }
        metadata.append(metadata_item)
        
        # 重命名文件
        old_path = os.path.join(folder_path, old_filename)
        new_path = os.path.join(folder_path, new_filename)
        os.rename(old_path, new_path)
    
    # 写入 metadata.jsonl 文件
    with open(os.path.join(folder_path, 'metadata.jsonl'), 'w', encoding='utf-8') as f:
        for item in metadata:
            json.dump(item, f, ensure_ascii=False)
            f.write('\n')
def wash_data(file_name:str):
    import copy
    new_file_name = file_name.split('.')[0] + '_new.jsonl'
    with open(file_name, 'r', encoding='utf-8') as f:
        with open(new_file_name, 'w', encoding='utf-8') as new_file:
            for line in f:
                data = json.loads(line.strip())
                description = data['text'].lower()
                des_list = description.split(',')
                des_list = [i.strip().replace(' ', '_') for i in des_list]
                des_list = list(set(des_list))
                print(des_list)
                del_list = ['hair','eye', 'background', 'leg', 'girl', 'realistic', 'breast', 'ass', 'navel', 'chest', 'skin', 'back', 'behind', 'look']
                # print(des_list)
                for des in copy.deepcopy(des_list):
                    des = des.strip().replace(' ', '_')
                    for detect in del_list:
                        if detect in des:
                            des_list.remove(des)
                            break
                des_list = [i.replace('_', '-').replace('-',' ') for i in des_list]

                new_des = ', '.join(des_list)
                data['text'] = new_des
                new_file.write(json.dumps(data))
                new_file.write('\n')
def create_caption_files(folder_path):
    """
    在指定文件夹中为图片创建对应的.caption文件。
    
    参数:
    folder_path (str): 包含图片和metadata.jsonl文件的文件夹路径
    
    返回:
    int: 成功创建的.caption文件数量
    """
    metadata_file = os.path.join(folder_path, 'metadata.jsonl')
    created_files = 0

    try:
        with open(metadata_file, 'r', encoding='utf-8') as f:
            for line in f:
                data = json.loads(line.strip())
                image_name = data['file_name']
                description = data['text']
                
                caption_name = os.path.splitext(image_name)[0] + '.caption'
                caption_path = os.path.join(folder_path, caption_name)
                
                with open(caption_path, 'w', encoding='utf-8') as caption_file:
                    caption_file.write(description)
                
                created_files += 1
        
        print(f"处理完成。成功创建了 {created_files} 个.caption文件。")
        return created_files

    except FileNotFoundError:
        print(f"错误：在 {folder_path} 中未找到 metadata.jsonl 文件。")
        return 0
    except json.JSONDecodeError:
        print("错误：metadata.jsonl 文件格式不正确。")
        return 0
    except Exception as e:
        print(f"发生错误：{str(e)}")
        return 0

# 使用示例
if __name__ == "__main__":
    # 使用示例
    folder_path = '/code/train-car'
    create_metadata_and_rename(folder_path)

    folder_path = '/code/train-car'
    num_files = create_caption_files(folder_path)
    print(f"总共创建了 {num_files} 个.caption文件。")

    # file_name = '/code/train-1/metadata'
    # wash_data(file_name)
