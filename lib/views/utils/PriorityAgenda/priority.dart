enum Priority {DISCRETIONARY,URGENT,ROUTINE}

Priority valueOf(int value)
{
  switch(value)
  {
    case 0:
      return Priority.DISCRETIONARY;
    case 1:
      return Priority.ROUTINE;
    case 2:
      return Priority.URGENT;
  }
  return null;
}

int intValue(Priority priority)
{
  switch(priority)
  {
    case Priority.DISCRETIONARY:
      return 0;
    case Priority.ROUTINE:
      return 1;
    case Priority.URGENT:
      return 2;
  }
  return -1;
}
