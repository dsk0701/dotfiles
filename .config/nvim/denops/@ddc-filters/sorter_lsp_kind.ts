import { type Item } from "jsr:@shougo/ddc-vim@~9.1.0/types";
import { BaseFilter } from "jsr:@shougo/ddc-vim@~9.1.0/filter";

import type { Denops } from "jsr:@denops/core@~7.0.0";

const KIND_PRIORITY: Record<string, number> = {
  Property: 0,
  Field: 0,
  Method: 1,
  Function: 2,
  Variable: 3,
  Constant: 3,
  EnumMember: 4,
  Enum: 5,
  Class: 6,
  Struct: 6,
  Interface: 6,
  Module: 7,
  Constructor: 8,
  Keyword: 9,
  Snippet: 10,
  Text: 11,
};

const DEFAULT_PRIORITY = 7;

type Params = Record<string, never>;

export class Filter extends BaseFilter<Params> {
  override filter(args: {
    denops: Denops;
    completeStr: string;
    items: Item[];
  }): Promise<Item[]> {
    return Promise.resolve(
      args.items.sort((a, b) => {
        const kindA = KIND_PRIORITY[a.kind ?? ""] ?? DEFAULT_PRIORITY;
        const kindB = KIND_PRIORITY[b.kind ?? ""] ?? DEFAULT_PRIORITY;
        return kindA - kindB;
      }),
    );
  }

  override params(): Params {
    return {};
  }
}
