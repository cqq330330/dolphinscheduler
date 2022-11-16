/*
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.apache.dolphinscheduler.plugin.task.sqoop.parameter;

import lombok.extern.slf4j.Slf4j;
import org.apache.dolphinscheduler.plugin.task.api.enums.ResourceType;
import org.apache.dolphinscheduler.plugin.task.api.model.Property;
import org.apache.dolphinscheduler.plugin.task.api.parameters.AbstractParameters;
import org.apache.dolphinscheduler.plugin.task.api.parameters.resource.DataSourceParameters;
import org.apache.dolphinscheduler.plugin.task.api.parameters.resource.ResourceParametersHelper;
import org.apache.dolphinscheduler.plugin.task.sqoop.SqoopJobType;
import org.apache.dolphinscheduler.plugin.task.sqoop.SqoopTaskExecutionContext;
import org.apache.dolphinscheduler.plugin.task.sqoop.parameter.sources.SourceMysqlParameter;
import org.apache.dolphinscheduler.plugin.task.sqoop.parameter.sources.SourceXuguParameter;
import org.apache.dolphinscheduler.plugin.task.sqoop.parameter.targets.TargetMysqlParameter;
import org.apache.dolphinscheduler.plugin.task.sqoop.parameter.targets.TargetXuguParameter;
import org.apache.dolphinscheduler.spi.utils.JSONUtils;
import org.apache.dolphinscheduler.spi.utils.StringUtils;

import java.util.List;
import java.util.Objects;

/**
 * sqoop parameters
 */
public class SqoopParameters  extends AbstractParameters {

    /**
     * sqoop job type:
     * CUSTOM - custom sqoop job
     * TEMPLATE - sqoop template job
     */
    private String jobType;

    /**
     * customJob eq 1, use customShell
     */
    private String customShell;

    /**
     * sqoop job name - map-reduce job name
     */
    private String jobName;

    /**
     * model type
     */
    private String modelType;
    /**
     * concurrency
     */
    private int concurrency;
    /**
     * source type
     */
    private String sourceType;
    /**
     * target type
     */
    private String targetType;
    /**
     * source params
     */
    private String sourceParams;
    /**
     * target params
     */
    private String targetParams;

    /**
     * hadoop custom param for sqoop job
     */
    private List<Property> hadoopCustomParams;

    /**
     * sqoop advanced param
     */
    private List<Property> sqoopAdvancedParams;

    public String getModelType() {
        return modelType;
    }

    public void setModelType(String modelType) {
        this.modelType = modelType;
    }

    public int getConcurrency() {
        return concurrency;
    }

    public void setConcurrency(int concurrency) {
        this.concurrency = concurrency;
    }

    public String getSourceType() {
        return sourceType;
    }

    public void setSourceType(String sourceType) {
        this.sourceType = sourceType;
    }

    public String getTargetType() {
        return targetType;
    }

    public void setTargetType(String targetType) {
        this.targetType = targetType;
    }

    public String getSourceParams() {
        return sourceParams;
    }

    public void setSourceParams(String sourceParams) {
        this.sourceParams = sourceParams;
    }

    public String getTargetParams() {
        return targetParams;
    }

    public void setTargetParams(String targetParams) {
        this.targetParams = targetParams;
    }

    public String getJobType() {
        return jobType;
    }

    public void setJobType(String jobType) {
        this.jobType = jobType;
    }

    public String getJobName() {
        return jobName;
    }

    public void setJobName(String jobName) {
        this.jobName = jobName;
    }

    public String getCustomShell() {
        return customShell;
    }

    public void setCustomShell(String customShell) {
        this.customShell = customShell;
    }

    public List<Property> getHadoopCustomParams() {
        return hadoopCustomParams;
    }

    public void setHadoopCustomParams(List<Property> hadoopCustomParams) {
        this.hadoopCustomParams = hadoopCustomParams;
    }

    public List<Property> getSqoopAdvancedParams() {
        return sqoopAdvancedParams;
    }

    public void setSqoopAdvancedParams(List<Property> sqoopAdvancedParams) {
        this.sqoopAdvancedParams = sqoopAdvancedParams;
    }

    @Override
    public boolean checkParameters() {

        boolean sqoopParamsCheck = false;

        if (StringUtils.isEmpty(jobType)) {
            return sqoopParamsCheck;
        }

        if (SqoopJobType.TEMPLATE.getDescp().equals(jobType)) {
            sqoopParamsCheck = StringUtils.isEmpty(customShell)
                    && StringUtils.isNotEmpty(modelType)
                    && StringUtils.isNotEmpty(jobName)
                    && concurrency != 0
                    && StringUtils.isNotEmpty(sourceType)
                    && StringUtils.isNotEmpty(targetType)
                    && StringUtils.isNotEmpty(sourceParams)
                    && StringUtils.isNotEmpty(targetParams);
        } else if (SqoopJobType.CUSTOM.getDescp().equals(jobType)) {
            sqoopParamsCheck = StringUtils.isNotEmpty(customShell)
                    && StringUtils.isEmpty(jobName);
        }

        return sqoopParamsCheck;
    }

    @Override
    public ResourceParametersHelper getResources() {
        ResourceParametersHelper resources = super.getResources();
        if (!SqoopJobType.TEMPLATE.getDescp().equals(this.getJobType())) {
            return resources;
        }

        SourceMysqlParameter sourceMysqlParameter = JSONUtils.parseObject(this.getSourceParams(), SourceMysqlParameter.class);
        if (sourceMysqlParameter.getSrcDatasource() != 0) {
            resources.put(ResourceType.DATASOURCE, sourceMysqlParameter.getSrcDatasource());
        }

        TargetMysqlParameter targetMysqlParameter = JSONUtils.parseObject(this.getTargetParams(), TargetMysqlParameter.class);
        if (targetMysqlParameter.getTargetDatasource() != 0) {
            resources.put(ResourceType.DATASOURCE, targetMysqlParameter.getTargetDatasource());
        }

        SourceXuguParameter sourceXuguParameter = JSONUtils.parseObject(this.getSourceParams(), SourceXuguParameter.class);
        if (sourceXuguParameter.getSrcDatasource() != 0) {
            resources.put(ResourceType.DATASOURCE, sourceXuguParameter.getSrcDatasource());
        }

        TargetXuguParameter targetXuguParameter = JSONUtils.parseObject(this.getTargetParams(), TargetXuguParameter.class);
        if (targetXuguParameter.getTargetDatasource() != 0) {
            resources.put(ResourceType.DATASOURCE, targetXuguParameter.getTargetDatasource());
        }

        return resources;
    }

    public SqoopTaskExecutionContext generateExtendedContext(ResourceParametersHelper parametersHelper) {

        SqoopTaskExecutionContext sqoopTaskExecutionContext = new SqoopTaskExecutionContext();
        if (!SqoopJobType.TEMPLATE.getDescp().equals(this.getJobType())) {
            return sqoopTaskExecutionContext;
        }

        SourceMysqlParameter sourceMysqlParameter = JSONUtils.parseObject(this.getSourceParams(), SourceMysqlParameter.class);
        TargetMysqlParameter targetMysqlParameter = JSONUtils.parseObject(this.getTargetParams(), TargetMysqlParameter.class);

        SourceXuguParameter sourceXuguParameter = JSONUtils.parseObject(this.getSourceParams(), SourceXuguParameter.class);
        TargetXuguParameter targetXuguParameter = JSONUtils.parseObject(this.getTargetParams(), TargetXuguParameter.class);

        DataSourceParameters dataSource = null;
        DataSourceParameters dataTarget = null;
        DataSourceParameters xugudataSource = null;
        DataSourceParameters xugudataTarget = null;
        if(Objects.nonNull(sourceMysqlParameter)){
            if (sourceMysqlParameter.getSrcDatasource() != 0) {
                dataSource = (DataSourceParameters) parametersHelper.getResourceParameters(ResourceType.DATASOURCE, sourceMysqlParameter.getSrcDatasource());
            }
        }

        if(Objects.nonNull(targetMysqlParameter)){
            if (targetMysqlParameter.getTargetDatasource() != 0) {
                dataTarget = (DataSourceParameters) parametersHelper.getResourceParameters(ResourceType.DATASOURCE, targetMysqlParameter.getTargetDatasource());
            }
        }

        if(Objects.nonNull(sourceXuguParameter)){
            if (sourceXuguParameter.getSrcDatasource() != 0) {
                xugudataSource = (DataSourceParameters) parametersHelper.getResourceParameters(ResourceType.DATASOURCE, sourceXuguParameter.getSrcDatasource());
            }
        }

        if(Objects.nonNull(targetXuguParameter)){
            if (targetXuguParameter.getTargetDatasource() != 0) {
                xugudataTarget = (DataSourceParameters) parametersHelper.getResourceParameters(ResourceType.DATASOURCE, targetXuguParameter.getTargetDatasource());
            }
        }

        if (Objects.nonNull(dataSource)) {
            sqoopTaskExecutionContext.setDataSourceId(sourceMysqlParameter.getSrcDatasource());
            sqoopTaskExecutionContext.setSourcetype(dataSource.getType());
            sqoopTaskExecutionContext.setSourceConnectionParams(dataSource.getConnectionParams());
        }

        if (Objects.nonNull(dataTarget)) {
            sqoopTaskExecutionContext.setDataTargetId(targetMysqlParameter.getTargetDatasource());
            sqoopTaskExecutionContext.setTargetType(dataTarget.getType());
            sqoopTaskExecutionContext.setTargetConnectionParams(dataTarget.getConnectionParams());
        }

        if (Objects.nonNull(xugudataSource)) {
            sqoopTaskExecutionContext.setDataSourceId(sourceXuguParameter.getSrcDatasource());
            sqoopTaskExecutionContext.setSourcetype(xugudataSource.getType());
            sqoopTaskExecutionContext.setSourceConnectionParams(xugudataSource.getConnectionParams());
        }

        if (Objects.nonNull(xugudataTarget)) {
            sqoopTaskExecutionContext.setDataTargetId(targetXuguParameter.getTargetDatasource());
            sqoopTaskExecutionContext.setTargetType(xugudataTarget.getType());
            sqoopTaskExecutionContext.setTargetConnectionParams(xugudataTarget.getConnectionParams());
        }

        return sqoopTaskExecutionContext;
    }
}
