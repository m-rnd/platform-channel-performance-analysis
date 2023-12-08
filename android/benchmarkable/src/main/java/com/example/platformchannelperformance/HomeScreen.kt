package com.example.platformchannelperformance

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import com.example.benchmarkable.BuildConfig


@Composable
fun HomeScreen(
    openFlutterActivity: () -> Unit,
    navigateToScroll: () -> Unit,
    navigateToInfiniteScroll: () -> Unit
) {
    Surface(
        modifier = Modifier.fillMaxSize(),
        color = MaterialTheme.colorScheme.background
    ) {
        Column(
            Modifier.fillMaxSize(),
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.Center
        ) {

            Text(
                BuildConfig.BUILD_TYPE,
                color = if (BuildConfig.DEBUG) MaterialTheme.colorScheme.error else MaterialTheme.colorScheme.primary
            )

            TextButton(onClick = navigateToScroll) {
                Text("native scroll")
            }

            TextButton(onClick = navigateToInfiniteScroll) {
                Text("native infinite scroll")
            }

            TextButton(onClick = openFlutterActivity) {
                Text("launch flutter view")
            }
        }
    }
}