import os
import shutil
from pathlib import Path

import docker


def extract_latest_whl(
    image_name: str = "zhyncs/trtllm:latest", output_dir: str = "./output"
):
    client = docker.from_env()
    container = client.containers.create(image_name)

    try:
        if Path(output_dir).exists():
            shutil.rmtree(output_dir)
        Path(output_dir).mkdir(parents=True)

        container.start()

        result = container.exec_run(
            "find /src/tensorrt_llm/build -name 'tensorrt_llm-*.whl'"
        )
        whl_files = result.output.decode().strip().split("\n")

        if not whl_files or not whl_files[0]:
            print("No whl files found")
            return

        latest_time = 0
        latest_whl = None

        for whl_file in whl_files:
            time_result = container.exec_run(f"stat -c %Y '{whl_file}'")
            file_time = int(time_result.output.decode().strip())
            if file_time > latest_time:
                latest_time = file_time
                latest_whl = whl_file

        if not latest_whl:
            print("Could not determine latest whl file")
            return

        print(f"Found latest whl: {latest_whl}")

        bits, _ = container.get_archive(latest_whl)
        output_path = Path(output_dir) / Path(latest_whl).name

        with open(output_path, "wb") as f:
            for chunk in bits:
                f.write(chunk)

        print(f"Latest whl extracted to: {output_path}")

    except Exception as e:
        print(f"Error: {e}")
    finally:
        container.stop()
        container.remove(force=True)


if __name__ == "__main__":
    extract_latest_whl()
