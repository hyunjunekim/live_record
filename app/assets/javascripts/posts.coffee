LiveRecord.store.post = LiveRecord.store.create(
  {
    model: 'post',
    plugins: {
      liveDom: true
    },
    callbacks: {
      'after:destroy': [
        ( ->
          console.log('AAA')
        ),
        ( ->
          console.log('BBB')
        )
      ]
    }
  },
)