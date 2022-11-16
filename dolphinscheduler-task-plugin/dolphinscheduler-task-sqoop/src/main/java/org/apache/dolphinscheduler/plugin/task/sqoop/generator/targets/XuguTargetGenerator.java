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

package org.apache.dolphinscheduler.plugin.task.sqoop.generator.targets;

import org.apache.dolphinscheduler.plugin.datasource.api.utils.DataSourceUtils;
import org.apache.dolphinscheduler.plugin.task.sqoop.SqoopTaskExecutionContext;
import org.apache.dolphinscheduler.plugin.task.sqoop.generator.ITargetGenerator;
import org.apache.dolphinscheduler.plugin.task.sqoop.parameter.SqoopParameters;
import org.apache.dolphinscheduler.plugin.task.sqoop.parameter.targets.TargetXuguParameter;
import org.apache.dolphinscheduler.spi.datasource.BaseConnectionParam;
import org.apache.dolphinscheduler.spi.enums.DbType;
import org.apache.dolphinscheduler.spi.utils.JSONUtils;
import org.apache.dolphinscheduler.spi.utils.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import static org.apache.dolphinscheduler.plugin.datasource.api.utils.PasswordUtils.decodePassword;
import static org.apache.dolphinscheduler.plugin.task.api.TaskConstants.*;
import static org.apache.dolphinscheduler.plugin.task.sqoop.SqoopConstants.*;

/**
 * xugu target generator
 */
public class XuguTargetGenerator implements ITargetGenerator {

    private static final Logger logger = LoggerFactory.getLogger(XuguTargetGenerator.class);

    @Override
    public String generate(SqoopParameters sqoopParameters, SqoopTaskExecutionContext sqoopTaskExecutionContext) {

        StringBuilder xuguTargetSb = new StringBuilder();

        try {
            TargetXuguParameter targetXuguParameter =
                JSONUtils.parseObject(sqoopParameters.getTargetParams(), TargetXuguParameter.class);

            if (null != targetXuguParameter && targetXuguParameter.getTargetDatasource() != 0) {

                // get datasource
                BaseConnectionParam baseDataSource = (BaseConnectionParam) DataSourceUtils.buildConnectionParams(
                        sqoopTaskExecutionContext.getTargetType(),
                        sqoopTaskExecutionContext.getTargetConnectionParams());

                if (null != baseDataSource) {

                    xuguTargetSb.append(SPACE).append(DB_CONNECT)
                            .append(SPACE).append(DOUBLE_QUOTES)
                            .append(DataSourceUtils.getJdbcUrl(DbType.XUGU, baseDataSource)).append(DOUBLE_QUOTES)
                            .append(SPACE).append(DB_DRIVER)
                            .append(SPACE).append(XUGU_DRIVER_CLASSNAME)
                            .append(SPACE).append(DB_USERNAME)
                            .append(SPACE).append(baseDataSource.getUser())
                            .append(SPACE).append(DB_PWD)
                            .append(SPACE).append(DOUBLE_QUOTES)
                            .append(decodePassword(baseDataSource.getPassword())).append(DOUBLE_QUOTES)
                        .append(SPACE).append(TABLE)
                        .append(SPACE).append(targetXuguParameter.getTargetTable());

                    if (StringUtils.isNotEmpty(targetXuguParameter.getTargetColumns())) {
                        xuguTargetSb.append(SPACE).append(COLUMNS)
                            .append(SPACE).append(targetXuguParameter.getTargetColumns());
                    }

                    if (StringUtils.isNotEmpty(targetXuguParameter.getFieldsTerminated())) {
                        xuguTargetSb.append(SPACE).append(FIELDS_TERMINATED_BY);
                        if (targetXuguParameter.getFieldsTerminated().contains("'")) {
                            xuguTargetSb.append(SPACE).append(targetXuguParameter.getFieldsTerminated());

                        } else {
                            xuguTargetSb.append(SPACE).append(SINGLE_QUOTES).append(targetXuguParameter.getFieldsTerminated()).append(SINGLE_QUOTES);
                        }
                    }

                    if (StringUtils.isNotEmpty(targetXuguParameter.getLinesTerminated())) {
                        xuguTargetSb.append(SPACE).append(LINES_TERMINATED_BY);
                        if (targetXuguParameter.getLinesTerminated().contains(SINGLE_QUOTES)) {
                            xuguTargetSb.append(SPACE).append(targetXuguParameter.getLinesTerminated());
                        } else {
                            xuguTargetSb.append(SPACE).append(SINGLE_QUOTES).append(targetXuguParameter.getLinesTerminated()).append(SINGLE_QUOTES);
                        }
                    }

                    if (targetXuguParameter.getIsUpdate()
                        && StringUtils.isNotEmpty(targetXuguParameter.getTargetUpdateKey())
                        && StringUtils.isNotEmpty(targetXuguParameter.getTargetUpdateMode())) {
                        xuguTargetSb.append(SPACE).append(UPDATE_KEY)
                            .append(SPACE).append(targetXuguParameter.getTargetUpdateKey())
                            .append(SPACE).append(UPDATE_MODE)
                            .append(SPACE).append(targetXuguParameter.getTargetUpdateMode());
                    }
                }
            }
        } catch (Exception e) {
            logger.error(String.format("Sqoop xugu target params build failed: [%s]", e.getMessage()));
        }

        return xuguTargetSb.toString();
    }
}
