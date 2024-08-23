
E:dalin-lxmodel-materialsstable-diffusion-v1-5
accelerate launch --mixed_precision="fp16" train_text_to_image_lora.py 
  --pretrained_model_name_or_path=/mnt/e/dalin-lx/model-materials/stable-diffusion-v1-5 
  --train_data_dir=/code/train-1 
  --caption_column="text" 
  --resolution=512 --random_flip 
  --train_batch_size=1 
  --max_train_steps=5500 
  --learning_rate=1e-05 
  --max_grad_norm=1 
  --num_train_epochs=100 --checkpointing_steps=1000 
  --lr_scheduler="constant" --lr_warmup_steps=0 
  --output_dir="sd-naruto-model-1"

accelerate launch --mixed_precision="fp16" train_text_to_image_lora.py 
  --pretrained_model_name_or_path=/mnt/e/dalin-lx/model-materials/stable-diffusion-v1-5 
  --train_data_dir=/code/train-1 
  --caption_column="text"
  --resolution=512 --random_flip 
  --train_batch_size=3 
  --num_train_epochs=100 --checkpointing_steps=1000 
  --learning_rate=1e-05 --lr_scheduler="constant" --lr_warmup_steps=3 
  --seed=42 
  --output_dir="sd-naruto-model-lora" 
  --validation_prompt="Black Tie Bikini, long_hair, simple_background, black_hair, white_background, swimsuit, ass, bikini, from_behind, profile, black_bikini, back, looking_away, realistic"

# kohya_ss 的 sdxl的lora微调
accelerate launch --num_cpu_threads_per_process 1 /code/sd-scripts/sdxl_train_network.py --pretrained_model_name_or_path=/mnt/e/dalin-lx/model-materials/sdxl-turbo/sd_xl_turbo_1.0_fp16.safetensors --dataset_config=/code/sd-train/train_db_caption_instance.toml --output_dir=/code/sd-train/ --output_name=car_db_train --save_model_as=safetensors --prior_loss_weight=1.0 --max_train_steps=1400 --learning_rate=1e-6 --optimizer_type="AdamW8bit" --xformers --mixed_precision="fp16" --cache_latents --gradient_checkpointing --network_module=networks.lora --no_half_vae

# kohya_ss 的 dreambooth微调/clothes
accelerate launch --num_cpu_threads_per_process 1 /code/sd-scripts/train_db.py --pretrained_model_name_or_path=/code/sd-train/FilmGirl_Ultra.safetensors --dataset_config=/code/sd-train/train_db_caption.toml --output_dir=/code/sd-train/ --output_name=db_train --save_model_as=safetensors --prior_loss_weight=1.0 --max_train_steps=6510 --learning_rate=1e-6 --optimizer_type="AdamW8bit" --xformers --mixed_precision="fp16" --cache_latents --gradient_checkpointing

# kohya_ss 的 dreambooth微调/cars
accelerate launch --num_cpu_threads_per_process 1 /code/sd-scripts/train_db.py --pretrained_model_name_or_path=/code/sd-train/v1-5-pruned.safetensors --dataset_config=/code/sd-train/train_db_caption_car.toml --output_dir=/code/sd-train/ --output_name=db_train_car --save_model_as=safetensors --prior_loss_weight=1.0 --max_train_steps=980 --learning_rate=1e-6 --optimizer_type="AdamW8bit" --xformers --mixed_precision="fp16" --cache_latents --gradient_checkpointing

# diffusers 的 sd3 的dreambooth微调
accelerate launch train_dreambooth_sd3.py --pretrained_model_name_or_path=/mnt/e/dalin-lx/model-materials/stable-diffusion-3-medium --instance_data_dir=/code/train-car --output_dir=/code/sd-train --mixed_precision="fp16" --instance_prompt="Mazda, Rx7, retro futurism, JDM, body knits , minimalism, mecha, negative space, sleek, front bumper, air intake, engine hood, fender, headlight, fog lamp, low beam, high beam, side skirt, HUD futuristic, carbon fiber, rim, grille, side panel, front panel, wheel arch, rear bumper, rear wing, exhaust outlet" --resolution=1024 --train_batch_size=2 --gradient_accumulation_steps=4 --learning_rate=1e-4 --lr_scheduler="constant" --lr_warmup_steps=0 --max_train_steps=1000 --validation_prompt="Mazda, Rx7, retro futurism, JDM, body knits , minimalism, mecha, negative space, sleek, front bumper, air intake, engine hood, fender, headlight, fog lamp, low beam, high beam, side skirt, HUD futuristic, carbon fiber, rim, grille, side panel, front panel, wheel arch, rear bumper, rear wing, exhaust outlet," --validation_epochs=25 --use_8bit_adam

# kohya_ss 的 lora微调
accelerate launch --num_cpu_threads_per_process 1 train_network.py --pretrained_model_name_or_path=/code/sd-train/FilmGirl_Ultra.safetensors --dataset_config=/code/sd-train/train_lora_caption.toml --output_dir=/code/sd-train/ --output_name=lora_train --save_model_as=safetensors --prior_loss_weight=1.0 --max_train_steps=18200 --learning_rate=1e-4 --optimizer_type="AdamW8bit" --xformers --mixed_precision="fp16" --cache_latents --gradient_checkpointing --save_every_n_epochs=1 --network_module=networks.lora

# diffusers 的sdxl的lora微调
accelerate launch train_dreambooth_lora_sdxl.py --xformers --pretrained_model_name_or_path=/mnt/e/dalin-lx/model-materials/sdxl-turbo --instance_data_dir=/code/train-car --output_dir=/code/sd-train/ --mixed_precision="bf16" --instance_prompt="Mazda, Rx7, retro futurism, JDM, body knits , minimalism, mecha, negative space, sleek, front bumper, air intake, engine hood, fender, headlight, fog lamp, low beam, high beam, side skirt, HUD futuristic, carbon fiber, rim, grille, side panel, front panel, wheel arch, rear bumper, rear wing, exhaust outlet," --resolution=1024 --train_batch_size=4 --gradient_accumulation_steps=4 --learning_rate=1e-4 --lr_scheduler="constant" --lr_warmup_steps=0 --max_train_steps=980 --validation_prompt="Mazda, Rx7, retro futurism, JDM, body knits , minimalism, mecha, negative space, sleek, front bumper, air intake, engine hood, fender, headlight, fog lamp, low beam, high beam, side skirt, HUD futuristic, carbon fiber, rim, grille, side panel, front panel, wheel arch, rear bumper, rear wing, exhaust outlet," --validation_epochs=25 --seed="0"