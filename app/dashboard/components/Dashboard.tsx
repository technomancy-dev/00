// @ts-nocheck

const Dashboard = ({ records }) => {
  return (
    <div class="max-w-xl mx-auto">
      <div class="w-full my-10 flex justify-between">
        <a class="btn btn-ghost" href="/dashboard/keys">
          Upgrade to pro
        </a>
        <a class="btn btn-primary" href="/dashboard/keys">
          Edit Keys
        </a>
      </div>
      <div class="overflow-x-auto">
        <table class="table">
          {/* head */}
          <thead>
            <tr>
              <th></th>
              <th>Name</th>
              <th>Job</th>
              <th>Favorite Color</th>
            </tr>
          </thead>
          <tbody>
            {/* row 1 */}
            <tr>
              <th>1</th>
              <td>Cy Ganderton</td>
              <td>Quality Control Specialist</td>
              <td>Blue</td>
            </tr>
            {/* row 2 */}
            <tr>
              <th>2</th>
              <td>Hart Hagerty</td>
              <td>Desktop Support Technician</td>
              <td>Purple</td>
            </tr>
            {/* row 3 */}
            <tr>
              <th>3</th>
              <td>Brice Swyre</td>
              <td>Tax Accountant</td>
              <td>Red</td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  );
};

export default Dashboard;
