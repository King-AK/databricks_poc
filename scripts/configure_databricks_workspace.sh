# Install Databricks CLI

# Set up venv
rm -rf ./venv
python3.10 -m venv ./venv
source ./venv/bin/activate

# Install requirements
requirements_file="requirements.txt"
pip install --upgrade pip
pip install wheel
pip install setuptools
echo "Installing requirements from ${requirements_file}..."
pip install -r ${requirements_file}
echo "Installed requirements from ${requirements_file}..."






