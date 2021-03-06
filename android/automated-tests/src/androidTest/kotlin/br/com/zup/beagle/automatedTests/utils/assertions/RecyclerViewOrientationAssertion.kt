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

package br.com.zup.beagle.automatedTests.utils.assertions

import android.view.View
import androidx.recyclerview.widget.GridLayoutManager
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import androidx.test.espresso.NoMatchingViewException
import androidx.test.espresso.ViewAssertion
import androidx.test.espresso.matcher.ViewMatchers
import org.hamcrest.CoreMatchers
import org.hamcrest.Matcher

class RecyclerViewOrientationAssertion(private val matcher: Matcher<Int>) : ViewAssertion {

    companion object {
        fun withOrientation(expectedCount: Int): RecyclerViewOrientationAssertion {
            return withOrientation(CoreMatchers.equalTo(expectedCount))
        }

        fun withOrientation(matcher: Matcher<Int>): RecyclerViewOrientationAssertion {
            return RecyclerViewOrientationAssertion(matcher)
        }
    }

    override fun check(view: View?, noViewFoundException: NoMatchingViewException?) {
        if (noViewFoundException != null) {
            throw noViewFoundException
        }

        if (view !is RecyclerView) {
            throw IllegalStateException("The asserted view is not RecyclerView")
        }

        var layoutManager = view.layoutManager
            ?: throw IllegalStateException("No LayoutManager is assigned to RecyclerView")

        layoutManager = layoutManager as? LinearLayoutManager
            ?:
            throw IllegalStateException(
                "Unable to check RecyclerView orientation. LayoutManager isn't subclass of LinearLayoutManager"
            )

        ViewMatchers.assertThat("RecyclerView orientation", layoutManager.orientation, matcher)
    }
}