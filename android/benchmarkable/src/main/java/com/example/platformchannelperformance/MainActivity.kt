package com.example.platformchannelperformance

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import com.example.platformchannelperformance.infinitescroll.InfiniteScrollScreen
import com.example.platformchannelperformance.infinitescroll.ScrollScreen
import com.example.platformchannelperformance.measuring.FpsMonitor
import com.example.platformchannelperformance.ui.theme.PlatformChannelPerformanceTheme
import io.flutter.embedding.android.FlutterActivity

enum class NavDestination(val desc: String) {
    HOME("home"),
    SCROLL_NATIVE("scroll_native"),
    INFINITY_SCROLL_NATIVE("infinity_scroll_native")
}

class MainActivity : ComponentActivity() {

    // stop FPS monitorings from previous screens
    override fun onStart() {
        super.onStart()
        FpsMonitor.stop()
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        FlutterDependencies(this)

        setContent {
            PlatformChannelPerformanceTheme {
                val navController = rememberNavController()

                NavHost(
                    navController = navController,
                    startDestination = NavDestination.HOME.desc
                ) {
                    composable("home") {
                        HomeScreen(
                            openFlutterActivity = {
                                Measuring.startMeasuring("flutter init")
                                val activity = FlutterActivity
                                    .withCachedEngine(FlutterDependencies.ENGINE_ID)
                                    .build(this@MainActivity)
                                startActivity(activity)
                            },
                            navigateToScroll = {
                                navController.navigate(NavDestination.SCROLL_NATIVE.desc)
                            },
                            navigateToInfiniteScroll = {
                                navController.navigate(NavDestination.INFINITY_SCROLL_NATIVE.desc)
                            },
                        )
                    }

                    composable(NavDestination.INFINITY_SCROLL_NATIVE.desc) {
                        InfiniteScrollScreen(
                            navigateUp = {
                                navController.navigateUp()
                            }
                        )
                    }

                    composable(NavDestination.SCROLL_NATIVE.desc) {
                        ScrollScreen(
                            navigateUp = {
                                navController.navigateUp()
                            }
                        )
                    }
                }
            }
        }
    }
}