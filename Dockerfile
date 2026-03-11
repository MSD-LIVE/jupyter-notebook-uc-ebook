FROM ghcr.io/msd-live/jupyter/datascience-notebook:latest

USER root

RUN git clone --depth=1 --branch=main https://github.com/IMMM-SFA/msd_uncertainty_ebook.git msd_uncertainty_ebook
RUN cd msd_uncertainty_ebook && pip install .

# Install msdbook data
RUN mkdir -p /opt/conda/lib/python3.11/site-packages/msdbook/data
RUN python -c 'from msdbook.install_supplement import install_package_data; install_package_data()'
# support for pd.unique() with arguments that are not a Series, Index, ExtensionArray, 
# or np.ndarray was deprecated in pandas 1.4.0 and subsequently removed in pandas 3.0.0
# uc-ebook uses SALib, which inturn has "pandas>=2.0" as a dependency but uses unique() with list argument, which causes the following error:
# TypeError: support for pd.unique() with arguments that are not a Series, Index, ExtensionArray, or np.ndarray is not supported. 
# so pinning pandas to a version < 3.0.0 to avoid this error. Once SALib updates their dependency to "pandas>=3.0", we can remove this pin.
RUN pip install --ignore-installed "pandas<3.0.0"

COPY notebooks /home/jovyan/notebooks
