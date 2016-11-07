Node: default to 0 because sometimes you'll build up circular
dependencies in the genome that cannot be resolved. If it can't be
resolved, we end up implicitly skipping some nodes and they must have a
value to avoid NullPointerExceptions


