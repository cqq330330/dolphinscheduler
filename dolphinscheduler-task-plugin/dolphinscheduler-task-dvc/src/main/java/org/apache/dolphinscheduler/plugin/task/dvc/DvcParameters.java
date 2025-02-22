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

package org.apache.dolphinscheduler.plugin.task.dvc;

import org.apache.dolphinscheduler.plugin.task.api.parameters.AbstractParameters;
import org.apache.dolphinscheduler.spi.utils.StringUtils;

import lombok.Data;

@Data
public class DvcParameters extends AbstractParameters {

    /**
     * common parameters
     */

    private String dvcTaskType;

    private String dvcRepository;

    private String dvcVersion;

    private String dvcDataLocation;

    private String dvcMessage;

    private String dvcLoadSaveDataPath;

    private String dvcStoreUrl;

    @Override
    public boolean checkParameters() {

        if (StringUtils.isEmpty(dvcTaskType)) {
            return false;
        }

        switch (dvcTaskType) {
            case DvcConstants.DVC_TASK_TYPE.UPLOAD:
                return StringUtils.isNotEmpty(dvcRepository) &&
                        StringUtils.isNotEmpty(dvcDataLocation) &&
                        StringUtils.isNotEmpty(dvcLoadSaveDataPath) &&
                        StringUtils.isNotEmpty(dvcVersion) &&
                        StringUtils.isNotEmpty(dvcMessage);

            case DvcConstants.DVC_TASK_TYPE.DOWNLOAD:
                return StringUtils.isNotEmpty(dvcRepository) &&
                        StringUtils.isNotEmpty(dvcDataLocation) &&
                        StringUtils.isNotEmpty(dvcLoadSaveDataPath) &&
                        StringUtils.isNotEmpty(dvcVersion);

            case DvcConstants.DVC_TASK_TYPE.INIT:
                return StringUtils.isNotEmpty(dvcRepository) &&
                        StringUtils.isNotEmpty(dvcStoreUrl);

            default:
                return false;
        }
    }
}
