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

import { onMounted, ref,watch, Ref } from 'vue'
import { queryDataSourceList } from '@/service/modules/data-source'
import { useI18n } from 'vue-i18n'
import type { IJsonItem, IDataBase } from '../types'
import {TypeReq} from "@/service/modules/data-source/types";
import {find} from "lodash";

export function useDatasource(
  model: { [field: string]: any },
  span: Ref,
  fieldType: string,
  fieldDatasource: string
): IJsonItem[] {
  const { t } = useI18n()
  const dataSourceList = ref([])
  const loading = ref(false)

  const getDataSource = async (type: IDataBase) => {
    if (loading.value) return
    loading.value = true
    const result = await queryDataSourceList({ type })
    dataSourceList.value = result.map((item: { name: string; id: number }) => ({
      label: item.name,
      value: item.id
    }))
    loading.value = false
  }
  const refreshOptionsSource = async (type: IDataBase) => {
    if (loading.value) return
    loading.value = true
    const result = await queryDataSourceList({ type })
    dataSourceList.value = result.map((item: { name: string; id: number }) => ({
      label: item.name,
      value: item.id
    }))
    loading.value = false
    if (!result.length && model.sourceMysqlDatasource) model.sourceMysqlDatasource = null
    if (result.length && model.sourceMysqlDatasource) {
      const item = find(result, { id: model.sourceMysqlDatasource })
      if (!item) {
        model.sourceMysqlDatasource = null
      }
    }
  }

  const refreshOptionsTarget = async (type: IDataBase) => {
    if (loading.value) return
    loading.value = true
    const result = await queryDataSourceList({ type })
    dataSourceList.value = result.map((item: { name: string; id: number }) => ({
      label: item.name,
      value: item.id
    }))
    loading.value = false
    if (!result.length && model.targetMysqlDatasource) model.targetMysqlDatasource = null
    if (result.length && model.targetMysqlDatasource) {
      const item = find(result, { id: model.targetMysqlDatasource })
      if (!item) {
        model.targetMysqlDatasource = null
      }
    }
  }

  const onChangeSource = (type: IDataBase) => {
    refreshOptionsSource(type)
  }

  const onChangeTarget = (type: IDataBase) => {
    refreshOptionsTarget(type)
  }

  onMounted(() => {
    getDataSource('MYSQL')
    //getDataSource('XUGU')
  })

  watch(
      () => [
        model.sourceMysqlType
      ],
      () => {
        onChangeSource(model.sourceMysqlType)
      }
  )

  watch(
      () => [
        model.targetMysqlType
      ],
      () => {
        onChangeSource(model.targetMysqlType)
      }
  )

  return [
    {
      type: 'select',
      field: fieldType,
      name: t('project.node.datasource'),
      span: span,
      options: [{ label: 'MYSQL', value: 'MYSQL' },{ label: 'XUGU', value: 'XUGU' }],
      validate: {
        required: true
      },
      props: {
        'on-update:value': onChangeTarget
      },
    },
    {
      type: 'select',
      field: fieldDatasource,
      name: ' ',
      span: span,
      props: {
        placeholder: t('project.node.datasource_tips'),
        filterable: true,
        loading
      },
      options: dataSourceList,
      validate: {
        trigger: ['blur', 'input'],
        validator(validate, value) {
          if (!value) {
            return new Error(t('project.node.datasource_tips'))
          }
        }
      }
    }
  ]
}
