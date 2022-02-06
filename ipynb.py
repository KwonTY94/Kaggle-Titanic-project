#!/usr/bin/env python
# coding: utf-8

# In[11]:


conda install -c conda-forge/label/gcc7 missingno


# In[ ]:


## Import modules


# In[44]:


import numpy as np
import pandas as pd
import missingno as msno
import matplotlib.pyplot as plt

get_ipython().run_line_magic('matplotlib', 'inline')


# In[19]:


## Import file(Should put 'r' in front to avoid SyntaxError)


# In[17]:


df_train=pd.read_csv(r'C:\Users\user\Desktop\데이터분석\220203 프로젝트1_titanic\train.csv')


# In[21]:


df_test=pd.read_csv(r'C:\Users\user\Desktop\데이터분석\220203 프로젝트1_titanic\test.csv')


# In[22]:


df_train.head()


# In[23]:


## Identify percentage of NaN in each columns


# In[49]:


for col in df_train.columns:
    msg = 'column: {:>10}\t Percent of NaN value: {:.2f}%'.format(col, 100*(df_train[col].isnull().sum() /df_train[col].shape[0]))
    print(msg)


# In[54]:


df_train[col].isnull().sum()


# In[47]:


##Thsu the number of NaN is 2


# In[58]:


df_train[col].isnull().sum()/df_train[col].shape[0]


# In[ ]:


## the eprcentage is null for the column 'Embarked' is 0.22%


# In[61]:


msno.matrix(df=df_train.iloc[:, :])


# In[62]:


## shows the distribution of nullx


# In[63]:


git in


# In[ ]:




