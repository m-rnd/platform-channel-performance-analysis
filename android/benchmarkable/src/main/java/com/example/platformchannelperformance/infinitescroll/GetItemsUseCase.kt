package com.example.platformchannelperformance.infinitescroll

import com.example.platformchannelperformance.measuring.FpsMonitor
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.onEach
import kotlinx.coroutines.flow.update

const val PAGE_SIZE = 10
const val PAGE_PRELOAD_COUNT = 1

data class Item(
    val id: Long,
    val header: String,
)

class GetItemsUseCase {

    private var lastPage = 0

    private val _items = MutableStateFlow<List<Item>>((emptyList<Item>()))
    val items = _items.asStateFlow()

    fun loadNewItems(targetPage: Int) {
        _items.update {
            it.toMutableList().apply {
                for (newPage in lastPage until targetPage) { // loop to add more than one page
                    for (i in 0L until PAGE_SIZE) { // add items to page
                        add(
                            Item(
                                id = newPage * PAGE_SIZE + i,
                                header = "Überschrift $i auf Seite $newPage"
                            )
                        )
                    }
                }
            }
        }
        FpsMonitor.log(-10.0)
        lastPage = targetPage
    }
}