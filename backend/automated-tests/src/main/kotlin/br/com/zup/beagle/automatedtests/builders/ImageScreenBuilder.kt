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

package br.com.zup.beagle.automatedtests.builders

import br.com.zup.beagle.core.Style
import br.com.zup.beagle.ext.applyStyle
import br.com.zup.beagle.ext.unitReal
import br.com.zup.beagle.widget.context.ContextData
import br.com.zup.beagle.widget.core.AlignSelf
import br.com.zup.beagle.widget.core.Flex
import br.com.zup.beagle.widget.core.ImageContentMode
import br.com.zup.beagle.widget.core.ScrollAxis
import br.com.zup.beagle.widget.core.Size
import br.com.zup.beagle.widget.core.UnitType
import br.com.zup.beagle.widget.core.UnitValue
import br.com.zup.beagle.widget.layout.Container
import br.com.zup.beagle.widget.layout.Screen
import br.com.zup.beagle.widget.layout.ScrollView
import br.com.zup.beagle.widget.ui.Image
import br.com.zup.beagle.widget.ui.ImagePath
import br.com.zup.beagle.widget.ui.ImagePath.Local
import br.com.zup.beagle.widget.ui.Text

const val LOGO_BEAGLE = "imageBeagle"
const val LOGO_BEAGLE_URL = "/public/logo.png"
const val IMAGE1 = "/image-web/1"
const val IMAGE2 = "/image-web/2"


data class ImageContextClass(val mobileImageId: String, val webImageUrl: String)

object ImageScreenBuilder {
    fun build() = Screen(
        child = ScrollView(
            scrollDirection = ScrollAxis.VERTICAL,
            children = listOf(
                Text(text = "Image Screen", styleId = "Image Screen"),
                buildImage("RemoteImage"),
                imagePathLocal(),
                imagePathRemote()
            )
        )
    )
    private fun buildImage(title: String, mode: ImageContentMode? = null) = Container(
        children = listOf(
           Text("Old Build"),
            Image(ImagePath.Remote("https://i.pinimg.com/564x/8a/2d/80/8a2d80b70dfd531befe563db81017331.jpg"), mode).applyStyle(Style(
                flex = Flex(
                    alignSelf = AlignSelf.CENTER
                ),
                size = Size(
                    width = 100.unitReal(),
                    height = 130.unitReal()
                ))
            )
        )
    )
    private fun imagePathLocal(): Container = Container(
        context = ContextData(
            id = "imageContextLocal",
            value = ImageContextClass(
                mobileImageId = "imageBeagle",
                webImageUrl = IMAGE1
            )),
        children = listOf(
            Text(text = "ImagePathSetByContext"),
            Image(Local.both(
                mobileId = "@{imageContextLocal.mobileImageId}",
                webUrl = "@{imageContextLocal.webImageUrl}")
            ),
            Text(text = "ImagePathSetHardcoded"),
            Image(Local.both(
                mobileId = "@{imageContextLocal.mobileImageId}",
                webUrl = "@{imageContextLocal.webImageUrl}")
            )
        ))

    private fun imagePathRemote(): Container = Container(
        context = ContextData(
            id = "imageContextRemote",
            value = ImageContextClass(
                mobileImageId = "beagle",
                webImageUrl = "http://localhost:8080/image-web/1"
            )),
        children = listOf(
            Image(
                path = ImagePath.Remote(
                    remoteUrl = "https://mcdn.wallpapersafari.com/medium/8/37/zlwnoM.jpg"
                )).applyStyle(style = Style(
                size = Size(
                    height = 130.unitReal(),
                    width = 150.unitReal())))
        ))

}
