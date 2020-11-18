/*
 * Copyright 2020 ZUP IT SERVICOS EM TECNOLOGIA E INOVACAO SA
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package br.com.zup.beagle.analytics2

import br.com.zup.beagle.android.BaseTest
import org.junit.Test
import org.junit.jupiter.api.Assertions.*

internal class ScreenReportCreatorTest : BaseTest(){

    @Test
    fun `WHEN createScreenLocalReport SHOULD create local screen report correctly`(){
        //WHEN
        val result = ScreenReportCreator.createScreenLocalReport("screenId")

        //THEN
        assertEquals("android", result.platform)
        assertEquals("screen", result.type)
        assertEquals(hashMapOf("screenId" to "screenId"), result.attributes)
    }

    @Test
    fun `WHEN createScreenRemoteReport SHOULD create remote screen report correctly`(){
        //WHEN
        val result = ScreenReportCreator.createScreenRemoteReport("url")

        //THEN
        assertEquals("android", result.platform)
        assertEquals("screen", result.type)
        assertEquals(hashMapOf("url" to "url"), result.attributes)
    }
}