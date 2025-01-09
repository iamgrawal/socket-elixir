%{
  configs: [
    %{
      name: "default",
      files: %{
        included: [
          "lib/",
          "test/"
        ],
        excluded: [
          ~r"/_build/",
          ~r"/deps/",
          ~r"/node_modules/"
        ]
      },
      strict: true,
      color: true,
      checks: [
        {Credo.Check.Consistency.TabsOrSpaces, []},
        {Credo.Check.Design.TagTODO, [exit_status: 0]},
        {Credo.Check.Readability.ModuleDoc, []},
        {Credo.Check.Readability.MaxLineLength, [priority: :low, max_length: 120]},
        {Credo.Check.Design.TagFIXME, [exit_status: 0]},
        
        # Custom checks
        {Credo.Check.Refactor.MapInto, false},
        {Credo.Check.Warning.LazyLogging, false}
      ]
    }
  ]
} 