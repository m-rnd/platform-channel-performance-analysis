package com.example.platformchannelperformance.infinitescroll

import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.itemsIndexed
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.ArrowBack
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.Divider
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.ListItem
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.material3.TopAppBar
import androidx.compose.runtime.Composable
import androidx.compose.runtime.DisposableEffect
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import com.example.platformchannelperformance.measuring.FpsMonitor


@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun InfiniteScrollScreen(
    navigateUp: () -> Unit,
) {
    // in a normal application, the ViewModel would be injected to Compose via a dependency framework
    val useCase by remember {
        mutableStateOf(GetItemsUseCase())
    }

    DisposableEffect(Unit) {
        FpsMonitor.start("T1b")
        onDispose { FpsMonitor.stop() }
    }

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("InfiniteScrollScreen") },
                navigationIcon = {
                    IconButton(onClick = navigateUp) {
                        Icon(Icons.Default.ArrowBack, contentDescription = null)
                    }
                }
            )
        }
    ) {
        Column(
            modifier = Modifier
                .padding(it)
                .fillMaxSize(),
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            InfiniteScrollList(
                infiniteScrollItems = useCase.items.collectAsState().value,
                loadNewItems = useCase::loadNewItems
            )
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
private fun InfiniteScrollList(
    infiniteScrollItems: List<Item>,
    loadNewItems: suspend (Int) -> Unit
) {
    var lastPage by remember { mutableStateOf(PAGE_PRELOAD_COUNT) }


    // load new Items on start and if loadItemsTrigger gets changed
    LaunchedEffect(Unit, lastPage) {
        loadNewItems(lastPage)
    }

    // list meta information for debugging and explaining
    Text("${infiniteScrollItems.size} Items geladen, letzte Seite: $lastPage")

    LazyColumn(
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        itemsIndexed(
            items = infiniteScrollItems,
            key = { _, item -> item.id }
        ) { index, item ->
            ListItem(
                headlineText = { Text(item.header) },
                leadingContent = { Text(item.id.toString()) }
            )
            Divider()

            // request new items if the last item of the previous-to-last page was initialized
            if (index >= infiniteScrollItems.size - PAGE_SIZE) {
                lastPage =
                    Math.max(lastPage, ((index + PAGE_SIZE) / PAGE_SIZE) + PAGE_PRELOAD_COUNT)
            }
        }
    }
}