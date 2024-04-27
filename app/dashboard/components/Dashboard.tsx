// @ts-nocheck
import { format } from "date-fns";
import { STATUS } from "../../aws/aws";

const COLOR_BY_STATUS = {
  [STATUS.Bounced]: "text-warning",
  [STATUS.Complained]: "text-error",
  [STATUS.Delivered]: "text-success",
};

const Dashboard = ({ records, limit, offset, firstPage, lastPage }) => {
  return (
    <div class="max-w-5xl mx-auto">
      <div class="w-full my-10 flex justify-between">
        <div>{/* Upgrade to pro */}</div>
        <a class="btn btn-primary" href="/dashboard/keys">
          Edit Keys
        </a>
      </div>
      <div class="overflow-x-auto">
        <div class="flex gap-4 items-center justify-end">
          <a
            disabled={firstPage}
            href={`?limit=${limit}&offset=${offset - 1}`}
            class="btn btn-ghost"
          >
            Previous
          </a>
          <div>
            {limit * (offset - 1)}-{limit * offset}
          </div>
          <a
            disabled={lastPage}
            href={`?limit=${limit}&offset=${offset + 1}`}
            class="btn btn-ghost"
          >
            Next
          </a>
        </div>
        <table class="table">
          {/* head */}
          <thead>
            <tr>
              <th>Status</th>
              <th>From</th>
              <th>To</th>
              <th>Sent</th>
            </tr>
          </thead>
          <tbody>
            {records.map((record) => (
              <tr>
                <th class={COLOR_BY_STATUS[record.status]}>{record.status}</th>
                <td>{record.from}</td>
                <td>{record.to}</td>
                <td>{format(record.created, "MM/dd/yy p")}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
};

export default Dashboard;
