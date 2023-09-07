FROM centos:7
MAINTAINER Doug White <dfwhite@unc.edu>

LABEL io.k8s.description="Datamine Jupyter Notebook Learning Modules" \
 io.k8s.display-name="Datamine Jupyter Notebook Learning Modules" \
 io.openshift.expose-services="8888:http"

USER root

ENV PYCURL_SSL_LIBRARY /home/notebook_user/nss
ENV JUPYTER_DATA_DIR /home/notebook_user/.local/share/jupyter
ENV JUPYTER_CONFIG_DIR /home/notebook_user/.jupyter
ENV JUPYTER_RUNTIME_DIR /home/notebook_user/.local/share/jupyter/runtime


# Install necessary OS packages and update
RUN yum-config-manager --enable rhel-server-rhscl-7-rpms
RUN yum -y install epel-release # installing EPEL first resolves errors for installing nodejs
RUN curl -sL https://rpm.nodesource.com/setup_8.x | bash -
RUN yum -y install nodejs nodejs010

RUN yum -y --skip-broken install \
           wget \
           openssl \
           openssl-devel \
           which \
           less \
           sudo \
           make \
           tree \
           openssl \
           libffi-dev \
           gcc-c++ \
           gcc \
           libcurl-devel \
           tar \
           gzip \
           unzip \
           scl-utils \
           libxml2-devel \
           R \
           npm \
           udunits2-devel \
           cairo-devel \
           mariadb-devel \
           cairo-devel \
           ImageMagick-c++-devel \
           zeromq-devel \
           gettext \
           libpqxx \
           libpqxx-devel \
           graphviz \
           python36 \
           python36-pip \
           python36-devel \
           libcurl-devel

# create notebook user
RUN useradd -m -p $(openssl passwd FoT4wsPfcbgeGDwBrr) notebook_user
RUN usermod -u 1001 notebook_user
RUN usermod -g 0 notebook_user
RUN chown -R notebook_user:root /home/notebook_user

# upgrade pip
RUN pip3 install --upgrade pip

# Install JupyterNotebook
RUN pip3 install jupyter
RUN pip3 install nltk
RUN pip3 install ipywidgets
RUN pip3 install jupyter_contrib_nbextensions
RUN pip3 install numpy==1.17.2
RUN pip3 install pandas==0.25.1
RUN pip3 install scipy==1.3.1
RUN pip3 install scikit-learn==0.21.3
RUN pip3 install scikit-image==0.14.3
RUN pip3 install matplotlib==3.1.1
RUN pip3 install seaborn==0.9.0
RUN pip3 install statsmodels==0.10.1
RUN pip3 install pydotplus==2.0.2
RUN pip3 install nltk==3.4.5
RUN pip3 install biopython==1.76
RUN pip3 install IPython==7.4.0
RUN pip3 install spacy==2.3.0
RUN pip3 install leather==0.3.3
RUN pip3 install covid==2.4.0
RUN pip3 install https://github.com/explosion/spacy-models/releases/download/en_core_web_sm-2.2.0/en_core_web_sm-2.2.0.tar.gz#egg=en_core_web_sm
RUN pip3 install jupyterlab==0.35.4

# copy notebooks
RUN mkdir -p /home/notebook_user/
RUN chmod -R 0777 /home/notebook_user
#RUN wget --no-check-certificate -O master.zip https://github.com/e-cui/Clinical-Cases-LAIR/archive/master.zip
#RUN unzip master.zip
#RUN mv /Clinical-Cases-LAIR-master /home/notebook_user/
#RUN wget --no-check-certificate -O master_new1.zip https://github.com/unc-chip/Clinical-Cases-LAIR/archive/master.zip
#RUN wget --no-check-certificate -O master_new2.zip https://github.com/unc-chip/Methods-in-Medical-Informatics/archive/master.zip
#RUN unzip master_new1.zip -d Clinical-Cases-LAIR-master_new
#RUN unzip master_new2.zip -d Clinical-Cases-LAIR-master_new
#RUN mv -f /Clinical-Cases-LAIR-master_new/Clinical-Cases-LAIR-master/Text\ Mining\ Modules/\(1\)\ Text\ Preprocessing.ipynb /home/notebook_user/Clinical-Cases-LAIR-master/Text\ Mining\ Modules/
RUN wget --no-check-certificate -O /home/notebook_user/master.zip https://github.com/unc-chip/Clinical-Cases-LAIR/archive/master.zip
RUN wget --no-check-certificate -O /home/notebook_user/master2.zip https://github.com/unc-chip/Methods-in-Medical-Informatics/archive/master.zip
RUN unzip /home/notebook_user/master.zip
RUN unzip /home/notebook_user/master2.zip
RUN pwd
RUN mkdir -p "/home/notebook_user/Clinical-Cases-LAIR-master/Data Mining Modules/userLibrary"
# Install R packages
RUN R -e "install.packages(c('IRkernel','tidyverse','GGally','randomForest','caret','forcats','cowplot','e1071','pROC','mice','gbm','rpart','rpart.plot'), dependencies=TRUE, repos='http://cran.us.r-project.org')"
RUN R -e "install.packages(c('ggplot2', 'dplyr', 'tidyr', 'readr', 'purrr', 'tibble', 'stringr', 'tidyverse','rzmq','repr','IRkernel','IRdisplay','caret','forcats','cowplot','e1071','pROC','mice','gbm','rpart','rpart.plot','dplyr','lattice','ggplot2','fastDummies', 'GGally', 'caret','tidyverse'), c('/usr/lib64/R/library/'), dependencies=TRUE, repos='http://cran.us.r-project.org')"
RUN R -e "IRkernel::installspec(user = FALSE)"

RUN R -e "packageurl <- 'https://cran.r-project.org/src/contrib/Archive/randomForest/randomForest_4.6-14.tar.gz';install.packages(packageurl, repos=NULL, type='source')"
RUN R -e "packageurl <- 'https://cran.r-project.org/src/contrib/Archive/fastICA/fastICA_1.2-2.tar.gz';install.packages(packageurl, repos=NULL, type='source')"
RUN R -e "packageurl <- 'https://cran.r-project.org/src/contrib/Archive/metafor/metafor_3.0-2.tar.gz';install.packages(packageurl, repos=NULL, type='source')"
RUN R -e "packageurl <- 'https://cran.r-project.org/src/contrib/Archive/itertools/itertools_0.1-1.tar.gz';install.packages(packageurl, repos=NULL, type='source')"
RUN R -e "packageurl <- 'https://cran.r-project.org/src/contrib/Archive/missForest/missForest_1.4.tar.gz';install.packages(packageurl, repos=NULL, type='source')"
USER root
#RUN pip3 install -r "/home/notebook_user/Clinical-Cases-LAIR-master/requirements.txt"

#USER notebook_user
RUN jupyter notebook --generate-config

RUN echo "c.NotebookApp.allow_remote_access = True" >> /home/notebook_user/.jupyter/jupyter_notebook_config.py
RUN echo "c.NotebookApp.ip = '0.0.0.0'" >> /home/notebook_user/.jupyter/jupyter_notebook_config.py
RUN echo "c.NotebookApp.open_browser = False" >> /home/notebook_user/.jupyter/jupyter_notebook_config.py
RUN echo "c.NotebookApp.password_required = False" >> /home/notebook_user/.jupyter/jupyter_notebook_config.py
RUN echo "c.NotebookApp.port = 8888" >> /home/notebook_user/.jupyter/jupyter_notebook_config.py
RUN echo "c.NotebookApp.token = ''" >> /home/notebook_user/.jupyter/jupyter_notebook_config.py
RUN echo "c.NotebookApp.notebook_dir = '/home/notebook_user/Clinical-Cases-LAIR-master'" >> /home/notebook_user/.jupyter/jupyter_notebook_config.py
RUN echo "c.NotebookApp.password = 'sha1:b39ab64d70ae:f28f1468a2f5ceca16cdfac6628864746dec68b1'"  >> /home/notebook_user/.jupyter/jupyter_notebook_config.py
RUN echo "c.NotebookApp.allow_password_change = False"
#USER root
RUN jupyter contrib nbextension install
RUN jupyter nbextension enable --py widgetsnbextension
RUN jupyter labextension install @jupyter-widgets/jupyterlab-manager@0.38
# Install Google Analytics for Jupyter Notebooks and then Configure with Google Analytics Tracking ID
#RUN pip3 install jupyteranalytics
#RUN sed -i 's/\"tracking_id\": null/\"tracking_id\": \"UA-153659007-1\"/' /usr/local/etc/jupyter/nbconfig/common.json
#RUN touch /tmp/cookies.txt
#RUN wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=1Ee0S0OVTl8PJ8RMw_MLrXYQhguuydtNR' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=1Ee0S0OVTl8PJ8RMw_MLrXYQhguuydtNR" -O /home/notebook_user/Clinical-Cases-LAIR-master/cases/data/h129.csv && rm -rf /tmp/cookies.txt
#USER root
#RUN chown -R root:root /home/notebook_user/Clinical-Cases-LAIR-master

# Start Jupyter Notebook
#USER notebook_user
WORKDIR "/home/notebook_user/"
ENV JUPYTER_DATA_DIR /home/notebook_user/.local/share/jupyter
ENV JUPYTER_CONFIG_DIR /home/notebook_user/.jupyter
ENV JUPYTER_RUNTIME_DIR /home/notebook_user/.local/share/jupyter/runtime
ENTRYPOINT ["jupyter" , "notebook"]

#CMD jupyterhub

WORKDIR "/home/notebook_user/"
ENV JUPYTER_DATA_DIR /home/notebook_user/.local/share/jupyter
ENV JUPYTER_CONFIG_DIR /home/notebook_user/.jupyter
ENV JUPYTER_RUNTIME_DIR /home/notebook_user/.local/share/jupyter/runtime

RUN jupyter nbextension enable collapsible_headings/main
RUN jupyter nbextension enable exercise/main
RUN jupyter nbextension enable exercise2/main
RUN jupyter nbextension enable toc2/main
RUN jupyter nbextension enable scroll_down/main
RUN jupyter nbextension enable rubberband/main
RUN jupyter nbextension enable splitcell/splitcell
RUN jupyter nbextension enable tree-filter/index
RUN jupyter nbextension enable move_selected_cells/main
RUN jupyter nbextension enable execution_dependencies/execution_dependencies
RUN jupyter nbextension enable execute_time/ExecuteTime
#RUN jupyter trust '/home/notebook_user/Clinical-Cases-LAIR-master/cases/Clinical Case - Asthma Expenditure (Python).ipynb'
#RUN jupyter trust '/home/notebook_user/Clinical-Cases-LAIR-master/cases/Clinical Case - Asthma Expenditure (R).ipynb'
#RUN jupyter trust '/home/notebook_user/Clinical-Cases-LAIR-master/cases/Clinical Case - Diabetes Among Pima Indians (Python).ipynb'
#RUN jupyter trust '/home/notebook_user/Clinical-Cases-LAIR-master/cases/Clinical Case - Diabetes Among Pima Indians (R).ipynb'
#RUN jupyter trust '/home/notebook_user/Clinical-Cases-LAIR-master/cases/Clinical Case - Medical Appointment No Show (Python).ipynb'
#RUN jupyter trust '/home/notebook_user/Clinical-Cases-LAIR-master/cases/Clinical Case - Medical Appointment No Show (R).ipynb'
#RUN jupyter trust '/home/notebook_user/Clinical-Cases-LAIR-master/cases/Clinical Case - Predicting Heart Disease (Python).ipynb'
#RUN jupyter trust '/home/notebook_user/Clinical-Cases-LAIR-master/cases/Clinical Case - Predicting Heart Disease (R).ipynb'
#RUN jupyter trust '/home/notebook_user/Clinical-Cases-LAIR-master/cases/Clinical Case - Predicting Stroke (Python).ipynb'
#RUN jupyter trust '/home/notebook_user/Clinical-Cases-LAIR-master/cases/Clinical Case - Predicting Stroke (R).ipynb'

# Configure Google Analytics for the notebooks for the notebook_user user
# Place the settings in the /home/notebook_user/.jupyter/nbconfig/common.json file
#RUN echo "{" >> /home/notebook_user/.jupyter/nbconfig/common.json
#RUN echo "    \"GoogleAnalytics\": {" >> /home/notebook_user/.jupyter/nbconfig/common.json
#RUN echo "        \"tracking_id\": \"UA-153659007-1\"" >> /home/notebook_user/.jupyter/nbconfig/common.json
#RUN echo "    }" >> /home/notebook_user/.jupyter/nbconfig/common.json
#RUN echo "}" >> /home/notebook_user/.jupyter/nbconfig/common.json

# Configure a password for the notebooks for the notebook_user user
# Place the settings in the /home/notebook_user/.jupyter/jupyter_notebook_config.json file
#RUN echo "{" >> /home/notebook_user/.jupyter/jupyter_notebook_config.json
#RUN echo "    \"NotebookApp\": {" >> /home/notebook_user/.jupyter/jupyter_notebook_config.json
#RUN echo "        \"password\": \"argon2:$argon2id$v=19$m=10240,t=10,p=8$+sW8ugZ0CpU6q1GD0OO8kg$8D9kbFeuvMRGGd5gZc4FGWaCeblbPH/EQStacnIsQHM\"" >> /home/notebook_user/.jupyter/jupyter_notebook_config.json
#RUN echo "    }" >> /home/notebook_user/.jupyter/jupyter_notebook_config.json
#RUN echo "}" >> /home/notebook_user/.jupyter/jupyter_notebook_config.json
#USER root
#WORKDIR "/home/notebook_user/"
#ENV JUPYTER_DATA_DIR /home/notebook_user/.local/share/jupyter
#ENV JUPYTER_CONFIG_DIR /home/notebook_user/.jupyter
#ENV JUPYTER_RUNTIME_DIR /home/notebook_user/.local/share/jupyter/runtime
RUN chown -R 1001 /home/notebook_user
RUN chgrp -R 0 /home/notebook_user
#RUN chmod -R g+w /home/notebook_user
#Below is based on RedHat OpenShift documentation
#RUN chmod -R ug+rwx /home/notebook_user
RUN chmod -R 0777 /home/notebook_user


#RUN chgrp -R root /home/notebook_user
#RUN find /home/notebook_user -type d -exec chmod g+rwx,o+rx {} \;
#RUN find /home/notebook_user -type f -exec chmod g+rw {} \; 

ENV HOME /home/notebook_user

USER 1001

# Make port 8888 available to the world outside this container
EXPOSE 8888

