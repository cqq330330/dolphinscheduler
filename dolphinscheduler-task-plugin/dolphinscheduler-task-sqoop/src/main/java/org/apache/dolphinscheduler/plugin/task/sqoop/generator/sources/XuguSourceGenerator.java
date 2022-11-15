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

package org.apache.dolphinscheduler.plugin.task.sqoop.generator.sources;

import org.apache.dolphinscheduler.plugin.datasource.api.utils.DataSourceUtils;
import org.apache.dolphinscheduler.plugin.task.api.model.Property;
import org.apache.dolphinscheduler.plugin.task.sqoop.SqoopQueryType;
import org.apache.dolphinscheduler.plugin.task.sqoop.SqoopTaskExecutionContext;
import org.apache.dolphinscheduler.plugin.task.sqoop.generator.ISourceGenerator;
import org.apache.dolphinscheduler.plugin.task.sqoop.parameter.SqoopParameters;
import org.apache.dolphinscheduler.plugin.task.sqoop.parameter.sources.SourceXuguParameter;
import org.apache.dolphinscheduler.spi.datasource.BaseConnectionParam;
import org.apache.dolphinscheduler.spi.enums.DbType;
import org.apache.dolphinscheduler.spi.utils.JSONUtils;
import org.apache.dolphinscheduler.spi.utils.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.List;

import static org.apache.dolphinscheduler.plugin.datasource.api.utils.PasswordUtils.decodePassword;
import static org.apache.dolphinscheduler.plugin.task.api.TaskConstants.*;
import static org.apache.dolphinscheduler.plugin.task.sqoop.SqoopConstants.*;

/**
 * xugu source generator
 */
public class XuguSourceGenerator implements ISourceGenerator {

    private static final Logger logger = LoggerFactory.getLogger(XuguSourceGenerator.class);

    @Override
    public String generate(SqoopParameters sqoopParameters, SqoopTaskExecutionContext sqoopTaskExecutionContext) {

        StringBuilder xuguSourceSb = new StringBuilder();

        try {
            SourceXuguParameter sourceXuguParameter = JSONUtils.parseObject(sqoopParameters.getSourceParams(), SourceXuguParameter.class);

            if (null != sourceXuguParameter) {
                BaseConnectionParam baseDataSource = (BaseConnectionParam) DataSourceUtils.buildConnectionParams(
                        sqoopTaskExecutionContext.getSourcetype(),
                        sqoopTaskExecutionContext.getSourceConnectionParams());

                if (null != baseDataSource) {

                    xuguSourceSb.append(SPACE).append(DB_CONNECT)
                            .append(SPACE).append(DOUBLE_QUOTES)
                            .append(DataSourceUtils.getJdbcUrl(DbType.XUGU, baseDataSource)).append(DOUBLE_QUOTES)
                        .append(SPACE).append(DB_USERNAME)
                        .append(SPACE).append(baseDataSource.getUser())
                        .append(SPACE).append(DB_PWD)
                        .append(SPACE).append(DOUBLE_QUOTES)
                            .append(decodePassword(baseDataSource.getPassword())).append(DOUBLE_QUOTES);

                    //sqoop table & sql query
                    if (sourceXuguParameter.getSrcQueryType() == SqoopQueryType.FORM.getCode()) {
                        if (StringUtils.isNotEmpty(sourceXuguParameter.getSrcTable())) {
                            xuguSourceSb.append(SPACE).append(TABLE)
                                .append(SPACE).append(sourceXuguParameter.getSrcTable());
                        }

                        if (StringUtils.isNotEmpty(sourceXuguParameter.getSrcColumns())) {
                            xuguSourceSb.append(SPACE).append(COLUMNS)
                                .append(SPACE).append(sourceXuguParameter.getSrcColumns());
                        }
                    } else if (sourceXuguParameter.getSrcQueryType() == SqoopQueryType.SQL.getCode()
                        && StringUtils.isNotEmpty(sourceXuguParameter.getSrcQuerySql())) {

                        String srcQuery = sourceXuguParameter.getSrcQuerySql();
                        xuguSourceSb.append(SPACE).append(QUERY)
                            .append(SPACE).append(DOUBLE_QUOTES).append(srcQuery);

                        if (srcQuery.toLowerCase().contains(QUERY_WHERE)) {
                            xuguSourceSb.append(SPACE).append(QUERY_CONDITION).append(DOUBLE_QUOTES);
                        } else {
                            xuguSourceSb.append(SPACE).append(QUERY_WITHOUT_CONDITION).append(DOUBLE_QUOTES);
                        }
                    }

                    //sqoop hive map column
                    List<Property> mapColumnHive = sourceXuguParameter.getMapColumnHive();

                    if (null != mapColumnHive && !mapColumnHive.isEmpty()) {
                        StringBuilder columnMap = new StringBuilder();
                        for (Property item : mapColumnHive) {
                            columnMap.append(item.getProp()).append(EQUAL_SIGN).append(item.getValue()).append(COMMA);
                        }

                        if (StringUtils.isNotEmpty(columnMap.toString())) {
                            xuguSourceSb.append(SPACE).append(MAP_COLUMN_HIVE)
                                .append(SPACE).append(columnMap.substring(0, columnMap.length() - 1));
                        }
                    }

                    //sqoop map column java
                    List<Property> mapColumnJava = sourceXuguParameter.getMapColumnJava();

                    if (null != mapColumnJava && !mapColumnJava.isEmpty()) {
                        StringBuilder columnMap = new StringBuilder();
                        for (Property item : mapColumnJava) {
                            columnMap.append(item.getProp()).append(EQUAL_SIGN).append(item.getValue()).append(COMMA);
                        }

                        if (StringUtils.isNotEmpty(columnMap.toString())) {
                            xuguSourceSb.append(SPACE).append(MAP_COLUMN_JAVA)
                                .append(SPACE).append(columnMap.substring(0, columnMap.length() - 1));
                        }
                    }
                }
            }
        } catch (Exception e) {
            logger.error(String.format("Sqoop task xugu source params build failed: [%s]", e.getMessage()));
        }

        return xuguSourceSb.toString();
    }
}
