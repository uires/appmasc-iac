cd /home/ubuntu
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
sudo python3 get-pip.py
sudo python3 -m pip install ansible
tee -a playbook.yml > /dev/null <<EOT
- hosts: localhost
  tasks: 
  - name: install python3 and virtualenv
    apt: 
      pkg: 
      - python3
      - virtualenv
      update_cache: yes
    become: yes
  - name: git clone source project
    ansible.builtin.git:
      repo: https://github.com/uires/clientes-api.git
      dest: /home/ubuntu/app/
      version: master
      force: yes
  - name: install django and django rest
    pip: 
      virtualenv: /home/ubuntu/app/venv
      requirements: /home/ubuntu/app/requirements.txt
  - name: changing default settings hosts
    lineinfile: 
      path: /home/ubuntu/app/setup/settings.py
      regexp: 'ALLOWED_HOSTS'
      line: 'ALLOWED_HOSTS = ["*"]'
      backrefs: yes
  - name: migrate database
    shell: '. /home/ubuntu/app/venv/bin/activate; python /home/ubuntu/app/manage.py migrate'
  - name: loading initial database
    shell: '. /home/ubuntu/app/venv/bin/activate; python /home/ubuntu/app/manage.py loaddata clientes.json'
  - name: initializer server
    shell: '. /home/ubuntu/app/venv/bin/activate; nohup python /home/ubuntu/app/manage.py runserver 0.0.0.0:8000 &'
EOT
ansible-playbook playbook.yml